import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:health/model/argument.dart';

// import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
import 'package:health/model/health.dart';
import 'package:health/model/user.dart';
import 'package:health/service/index.dart';
import 'package:health/store/profileNotify.dart';
import 'package:health/widget/index.dart';
import 'package:provider/provider.dart';

class HealthInfoReport extends StatefulWidget {
  final String title = '每日健康上报';
  @override
  _HealthInfoReportState createState() => _HealthInfoReportState();
}

class _HealthInfoReportState extends State<HealthInfoReport> {
  User user = Global.profile.user;
  List yesOrNo =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.BOOLEAN]);
  Health _health = new Health();
  @override
  void initState() {
    super.initState();
    _checkHasReport();
    _health = new Health(
        name: user.userName,
        classId: user.organId,
        personType: user.personType);
  }

  @override
  Widget build(BuildContext context) {
    final _arg = Provider.of<ProfileNotify>(context).argValue;

    // print('arg:$_arg.');
    if (_arg != null && _arg.params != null) {
      Health _thealth = _arg.params as Health;
      // print('_thealth:${filterEmpty(_thealth.toJson())}');
      this.setState(() {
        // _health = Object;
        _health = Health.fromJson(amap(_health.toJson(), _thealth.toJson()));
        // print('_health:${filterEmpty(_health.toJson())}');
      });
    }
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('姓名:'),
                  trailing: Text(user.userName ?? ''),
                ),
                Divider(height: 1),
                ListTile(
                  title: Text('所属班级:'),
                  trailing: Text(getLastIndex(user.organName)),
                ),
                Divider(height: 1),
                TextFormField(
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[.,0-9]"))
                  ],
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 15.0, right: 10.0),
                          child: Text('体温信息/(℃):',
                              style: Theme.of(context).textTheme.subtitle1)),
                      prefixIconConstraints: BoxConstraints()),
                  onChanged: (val) {
                    this.setState(() {
                      _health.temp = double.parse(val);
                    });
                  },
                ),
                Divider(height: 1),
                ListTile(
                    title: Text('接触疑似人员:'),
                    trailing: RadioOptions(
                      data: yesOrNo,
                      label: 'name',
                      onValueChange: (int _index) {
                        this.setState(() {
                          _health.isContactSuspect = yesOrNo[_index]['code'];
                        });
                      },
                    )),
                Divider(height: 1),
                ListTile(
                    title: Text('居家隔离:'),
                    trailing: RadioOptions(
                      data: yesOrNo,
                      label: 'name',
                      onValueChange: (int _index) {
                        this.setState(() {
                          _health.isDiscomfortHome = yesOrNo[_index]['code'];
                        });
                      },
                    )),
                Divider(height: 1),
                ListTile(
                  title: Text('家庭成员是否有不适症状:'),
                  trailing: RadioOptions(
                    data: yesOrNo,
                    label: 'name',
                    onValueChange: (int _index) {
                      this.setState(() {
                        _health.isDiscomfort = yesOrNo[_index]['code'];
                      });
                    },
                  ),
                ),
                Divider(height: 1),
                FLListTile(
                  title: Text('选择症状:'),
                  trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Text(_health.symptomTypeMultiValue != null
                            ? _health.symptomTypeMultiValue.join(',')
                            : ''),
                        Icon(Icons.navigate_next)
                      ]),
                  onTap: () {
                    Navigator.of(context).pushNamed('/healthSelectSym');
                  },
                ),
                Divider(height: 1),
                FLListTile(
                  title: Text('选择伤害:'),
                  trailing: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Text(_health.memo ?? ''),
                        Icon(Icons.navigate_next)
                      ]),
                  onTap: () {
                    Navigator.of(context).pushNamed('/healthSelect');
                  },
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
                  child: RaisedButton(
                    onPressed: _healthInfoReport,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text('提交'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        onWillPop: () {
          // print('返回');
          final _profileNotify =
              Provider.of<ProfileNotify>(context, listen: false);
          Argument args = Argument();
          args.params = null;

          _profileNotify.saveArg(args);
          return Future.value(true);
        });
  }

  Map amap(Map a, Map b) {
    a.forEach((key, _) {
      if (b[key] != null) {
        a[key] = b[key];
      }
    });
    // print('a${filterEmpty(a)}');
    return a;
  }

  String getLastIndex(String str) {
    if (str == null) return '';
    List<String> list = str.split('/');
    if (list.length > 0) {
      return list[list.length - 1];
    } else {
      return str;
    }
  }

  _healthInfoReport() async {
    // print('_health:${filterEmpty(_health.toJson())}');
    if (_health.temp == null) {
      EasyLoading.showInfo('体温未填写');
      return;
    }
    await healthInfoReport(health: _health);
  }

  _checkHasReport() async {
    var res = await checkHasReport(
        id: user.id, reportDay: new DateTime.now().toString());
    print('res:$res');
  }

  Map filterEmpty(Map s) {
    Map t = {};
    s.forEach((key, value) {
      if (s[key] != null) {
        t[key] = s[key];
      }
    });
    return t;
  }
}
