import 'package:date_format/date_format.dart';
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
  final String title = '家长上报';
  @override
  _HealthInfoReportState createState() => _HealthInfoReportState();
}

class _HealthInfoReportState extends State<HealthInfoReport> {
  User user = Global.profile.user;
  List yesOrNo =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.BOOLEAN]);
  Health _health = new Health();
  bool todayIsSubmit = false;
  final double maxTep = 45.0;
  final double minTep = 30.0;
  @override
  void initState() {
    super.initState();
    _checkHasReport();
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
            child: todayIsSubmit ? record() : form(),
            // child: form(),
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

  Widget form() {
    return Column(
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
          inputFormatters: [WhitelistingTextInputFormatter(RegExp("[.,0-9]"))],
          decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 15.0, right: 10.0),
                  child: Text('体温信息/(℃):',
                      style: Theme.of(context).textTheme.subtitle1)),
              prefixIconConstraints: BoxConstraints()),
          onChanged: (val) {
            print(val);
            this.setState(() {
              _health.temp = val == '' ? null : double.parse(val);
            });
          },
        ),
        Divider(height: 1),
        ListTile(
            title: Text('接触疑似人员:'),
            trailing: RadioOptions(
              data: yesOrNo,
              initIndex: 1,
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
              initIndex: 1,
              onValueChange: (int _index) {
                this.setState(() {
                  _health.isQuarantine = yesOrNo[_index]['code'];
                });
              },
            )),
        Divider(height: 1),
        ListTile(
          title: Text('家庭成员是否有不适症状:'),
          trailing: RadioOptions(
            data: yesOrNo,
            label: 'name',
            initIndex: 1,
            onValueChange: (int _index) {
              this.setState(() {
                _health.isDiscomfortHome = yesOrNo[_index]['code'];
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
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
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
    );
  }

  String ynLabel(String code) {
    return Dictionary.getNameByUniqueNameAndCode(
        uniqueName: UniqueNameValues[UNIQUE_NAME.BOOLEAN], code: code);
  }

  String symLabel(String code) {
    return Dictionary.getNameByUniqueNameAndCode(
        uniqueName: UniqueNameValues[UNIQUE_NAME.SYMPTOMTYPE], code: code);
  }

  String hurtLabel(String code) {
    return Dictionary.getNameByUniqueNameAndCode(
        uniqueName: UniqueNameValues[UNIQUE_NAME.HURTTYPE], code: code);
  }

  Widget record() {
    List<Map> list = [
      {'title': '姓名:', 'text': user.userName},
      {'title': '所属班级:', 'text': getLastIndex(user.organName)},
      {'title': '体温信息/(℃):', 'text': _health.temp.toString()},
      {
        'title': '接触疑似人员:',
        'text': ynLabel(_health.isContactSuspect),
        'type': 'chip'
      },
      {'title': '居家隔离:', 'text': ynLabel(_health.isQuarantine), 'type': 'chip'},
      {
        'title': '家庭成员是否有不是症状:',
        'text': ynLabel(_health.isDiscomfortHome),
        'type': 'chip'
      },
      {
        'title': '症状:',
        'text': _health.symptomTypeMulti == null
            ? '无'
            : _health.symptomTypeMulti
                .map((e) => symLabel(e))
                .toList()
                .join(','),
        'type': 'chip'
      },
      {
        'title': '伤害:',
        'text': _health.hurtType == null ? '无' : hurtLabel(_health.hurtType),
        'type': 'chip'
      }
    ];
    return Column(
      children: list
          .map((e) => Column(
                children: <Widget>[
                  ListTile(
                    title: Text(e['title']),
                    trailing: e['type'] == 'chip'
                        ? Chip(label: Text(e['text']))
                        : Text(e['text']),
                  ),
                  Divider(height: 1)
                ],
              ))
          .toList(),
    );
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
    print('_health:${filterEmpty(_health.toJson())}');
    if (_health.temp == null) {
      EasyLoading.showInfo('体温未填写');
      return;
    } else {
      if (_health.temp > maxTep || _health.temp < minTep) {
        EasyLoading.showInfo('体温数据异常,请检查是否是人类体温数据');
        return;
      }
    }
    var res = await healthInfoReport(health: _health);
    // print('res:$res');
    if (res != null && res['code'] == 0) {
      _checkHasReport();
    }
  }

  _checkHasReport() async {
    var res = await checkHasReport(
        reportDay: formatDate(new DateTime.now(), [yyyy, '-', mm, '-', dd]));
    // print('res:$res');
    if (res != null && res['list'].length > 0) {
      this.setState(() {
        todayIsSubmit = true;
        _health = Health.fromJson(res['list'][0]);
      });
    } else {
      this.setState(() {
        _health = new Health(
            name: user.userName,
            gender: user.gender,
            idCard: user.credNum,
            stuNum: user.loginName,
            classId: user.organId,
            isContactSuspect: '0',
            isDiscomfortHome: '0',
            isQuarantine: '0',
            personType: '1');
      });
    }
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
