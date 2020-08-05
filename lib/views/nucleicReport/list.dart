import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:health/model/argument.dart';

// import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
import 'package:health/model/nuclecReport.dart';
import 'package:health/model/user.dart';
import 'package:health/service/index.dart';
import 'package:health/store/profileNotify.dart';
import 'package:health/widget/index.dart';
import 'package:provider/provider.dart';

class NucleicList extends StatefulWidget {
  final String title = '核酸情况上报';
  @override
  _NucleicList createState() => _NucleicList();
}

class _NucleicList extends State<NucleicList> {
  User user = Global.profile.user;
  List yesOrNo =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.BOOLEAN]);
  NuclecReport _NuclecReport = new NuclecReport();
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
      NuclecReport _thealth = _arg.params as NuclecReport;
      // print('_thealth:${filterEmpty(_thealth.toJson())}');
      this.setState(() {
        // _health = Object;
        _NuclecReport = NuclecReport.fromJson(
            amap(_NuclecReport.toJson(), _thealth.toJson()));
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
        ListTile(
            title: Text('igG:'),
            trailing: RadioOptions(
              data: yesOrNo,
              initIndex: 1,
              label: 'name',
              onValueChange: (int _index) {
                this.setState(() {
                  _NuclecReport.igG = yesOrNo[_index]['code'];
                });
              },
            )),
        Divider(height: 1),
        ListTile(
            title: Text('igM:'),
            trailing: RadioOptions(
              data: yesOrNo,
              label: 'name',
              initIndex: 1,
              onValueChange: (int _index) {
                this.setState(() {
                  _NuclecReport.igM = yesOrNo[_index]['code'];
                });
              },
            )),
        Divider(height: 1),
        ListTile(
          title: Text('核酸:'),
          trailing: RadioOptions(
            data: yesOrNo,
            label: 'name',
            initIndex: 1,
            onValueChange: (int _index) {
              this.setState(() {
                _NuclecReport.heaInfoDailyNATDTOLisths =
                    yesOrNo[_index]['code'];
              });
            },
          ),
        ),
        Divider(height: 1),
        ImagePickerWidget(
          maxNum: 6,
          onValueChange: (List<File> files) {
            // print('file:${file.path}');
            this.setState(() {
              // leaveForm.file = [file];
              // if (files.length > 0) {
              _NuclecReport.report = files.map((e) => e.path).toList();
              // }
            });
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
          child: RaisedButton(
            onPressed: () {},
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
      {'title': 'igG:', 'text': ynLabel(_NuclecReport.igG), 'type': 'chip'},
      {'title': 'igM:', 'text': ynLabel(_NuclecReport.igG), 'type': 'chip'},
      {
        'title': '核酸:',
        'text': ynLabel(_NuclecReport.heaInfoDailyNATDTOLisths),
        'type': 'chip'
      },
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

  // _healthInfoReport() async {
  //   print('_health:${filterEmpty(_health.toJson())}');
  //   if (_health.temp == null) {
  //     EasyLoading.showInfo('体温未填写');
  //     return;
  //   } else {
  //     if (_health.temp > maxTep || _health.temp < minTep) {
  //       EasyLoading.showInfo('体温数据异常,请检查是否是人类体温数据');
  //       return;
  //     }
  //   }
  //   var res = await healthInfoReport(health: _health);
  //   // print('res:$res');
  //   if (res != null && res['code'] == 0) {
  //     _checkHasReport();
  //   }
  // }

  _checkHasReport() async {
    var res = await checkHasReport(
        reportDay: formatDate(new DateTime.now(), [yyyy, '-', mm, '-', dd]));
    // print('res:$res');
    if (res != null && res['list'].length > 0) {
      this.setState(() {
        todayIsSubmit = true;
        _NuclecReport = NuclecReport.fromJson(res['list'][0]);
      });
    } else {
      this.setState(() {
        _NuclecReport = new NuclecReport(
            name: user.userName,
            stuNum: user.loginName,
            classId: user.organId,
            igM: '0',
            igG: '0',
            heaInfoDailyNATDTOLisths: '0',
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
