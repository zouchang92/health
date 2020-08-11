import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';

// import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
import 'package:health/model/nuclecReport.dart';
import 'package:health/model/user.dart';
import 'package:health/service/index.dart';

import 'package:health/widget/index.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

class NucleicList extends StatefulWidget {
  final String title = '核酸情况上报';
  @override
  _NucleicList createState() => _NucleicList();
}

class _NucleicList extends State<NucleicList> {
  User user = Global.profile.user;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AppBarController appBarController = AppBarController();
  List yesOrNo =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.BOOLEAN]);
  List igg = Dictionary.getByUniqueName(
      UniqueNameValues[UNIQUE_NAME.IGGMANDHSSSTATUS]);

  List jl =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.CHECKRESULTS]);
  NuclecReport nuclecReport = NuclecReport();
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: SearchAppBar(
        appBarController: appBarController,
        primary: Theme.of(context).primaryColor,
        onChange: (String value) {},
        mainAppBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            InkWell(
                child: Icon(Icons.history),
                onTap: () {
                  Navigator.of(context).pushNamed('/nucleicHistory');
                })
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: todayIsSubmit ? record() : form(),
        // child: form(),
      ),
    );
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
        FLListTile(
          title: Text('检测时间:'),
          trailing: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(nuclecReport.checkTime ?? ''),
                Icon(Icons.calendar_today)
              ]),
          onTap: () {
            showDatePicker(
                    context: context,
                    initialDate: new DateTime.now(),
                    firstDate:
                        new DateTime.now().subtract(new Duration(days: 30)),
                    lastDate: new DateTime.now().add(new Duration(days: 30)))
                .then((value) => {
                      print('取消:$value'),
                      if (value != null)
                        {
                          this.setState(() {
                            nuclecReport.checkTime =
                                formatDate(value, [yyyy, '-', mm, '-', dd]);
                          })
                        }
                    });
          },
        ),
        Divider(height: 1),
        ListTile(
            title: Text('igG:'),
            trailing: RadioOptions(
              data: igg,
              // initIndex: 1,
              label: 'name',
              onValueChange: (int _index) {
                this.setState(() {
                  nuclecReport.igG = igg[_index]['code'];
                });
              },
            )),
        Divider(height: 1),
        ListTile(
            title: Text('igM:'),
            trailing: RadioOptions(
              data: igg,
              label: 'name',
              initIndex: 0,
              onValueChange: (int _index) {
                this.setState(() {
                  nuclecReport.igM = igg[_index]['code'];
                });
              },
            )),
        Divider(height: 1),
        ListTile(
          title: Text('核酸:'),
          trailing: RadioOptions(
            data: igg,
            label: 'name',
            initIndex: 0,
            onValueChange: (int _index) {
              this.setState(() {
                nuclecReport.hs = igg[_index]['code'];
              });
            },
          ),
        ),
        Divider(height: 1),
        ListTile(
          title: Text('检测结论:'),
          trailing: RadioOptions(
            data: jl,
            label: 'name',
            initIndex: 0,
            onValueChange: (int _index) {
              this.setState(() {
                nuclecReport.checkResult = jl[_index]['code'];
              });
            },
          ),
        ),
        Divider(height: 1),
        ImagePickerWidget(
          title: '核酸检测报告:',
          onValueChange: (List<File> files) {
            this.setState(() {
              if (files.length > 0) {
                // File file = files[0];
                nuclecReport.report = files[0].path;
                // nuclecReport.report = (files[0] as File).path;
              }
            });
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
          child: RaisedButton(
            onPressed: () {
              submit();
            },
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
      {'title': 'igG:', 'text': ynLabel(nuclecReport.igG), 'type': 'chip'},
      {'title': 'igM:', 'text': ynLabel(nuclecReport.igG), 'type': 'chip'},
      {'title': '核酸:', 'text': ynLabel(nuclecReport.hs), 'type': 'chip'},
      {
        'title': '检测结论',
        'text': ynLabel(nuclecReport.checkResult),
        'type': 'chip'
      },
      {'title': '核酸检测报告', 'text': 'nuclecReport.report', 'type': 'chip'}
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
        nuclecReport = NuclecReport.fromJson(res['list'][0]);
      });
    } else {
      this.setState(() {
        nuclecReport = new NuclecReport(
            name: user.userName,
            stuNum: user.loginName,
            classId: user.organId,
            gender: user.gender,
            checkResult: jl[0]['code'],
            igG: igg[0]['code'],
            igM: igg[0]['code'],
            hs: igg[0]['code'],
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

  Future submit() async {
    // print(nuclecReport);
    try {
      var res = await nucleicReportList(nuclecReport);
      // if (res != null && res['code'] == 0) {
      //   Navigator.of(context).pop();
      // }
    } catch (err) {
      print('err:$err');
    }
  }
}
