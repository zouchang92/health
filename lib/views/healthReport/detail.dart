import 'package:flutter/material.dart';
import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
import 'package:health/model/health.dart';
import 'package:health/model/user.dart';
import 'package:health/service/index.dart';

class HealthReportDetail extends StatelessWidget {
  final String title = '详细信息';
  final Argument arg;
  HealthReportDetail({
    this.arg,
  });
  final User user = Global.profile.user;
  final List yesOrNo =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.BOOLEAN]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            record(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
              child: RaisedButton(
                onPressed: () {
                  insertHeaInfoDaily(arg.params['id']);
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text('生成晨午检信息'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget record() {
    Health _health = Health.fromJson(arg.params);
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
        'text': _health.symptomTypeMulti ?? [],
        'type': 'chipList'
      },
      {
        'title': '伤害:',
        'text': _health.hurtType == null ? '无' : hurtLabel(_health.hurtType),
        'type': 'chip'
      }
    ];
    // List<Widget> chipList = [];

    return Column(
      children: list
          .map((e) => Column(
                children: <Widget>[
                  ListTile(
                    title: Text(e['title']),
                    trailing: e['type'] == 'chip'
                        ? Chip(label: Text(e['text']))
                        : (e['type'] == 'chipList')
                            ? Wrap(
                                children: (e['text'] as List)
                                    .map((e) => Chip(label: Text(symLabel(e))))
                                    .toList(),
                              )
                            : Text(e['text']),
                  ),
                  Divider(height: 1)
                ],
              ))
          .toList(),
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

  String getLastIndex(String str) {
    if (str == null) return '';
    List<String> list = str.split('/');
    if (list.length > 0) {
      return list[list.length - 1];
    } else {
      return str;
    }
  }
}
