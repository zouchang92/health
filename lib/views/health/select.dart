import 'package:flutter/material.dart';
import 'package:health/model/argument.dart';

import 'package:health/model/dictionary.dart';
import 'package:health/model/health.dart';

import 'package:health/store/profileNotify.dart';
import 'package:health/widget/index.dart';
import 'package:provider/provider.dart';

class HealthSelect extends StatefulWidget {
  final String title = '伤害选择';
  // final Argument argument;
  // HealthSelect({this.argument});
  @override
  _HealthSelectState createState() => _HealthSelectState();
}

class _HealthSelectState extends State<HealthSelect> {
  List hurtTypeList =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.HURTTYPE]);
  List hurtSiteList =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.HURTSITE]);

  int buttonDisabled = -1;
  List selectHurtTypeList = [];
  List selectHurtSiteList = [];

  /*赋值对象*/
  Argument args;

  // Map temArg = {};
  Health health = new Health();
  @override
  void initState() {
    // print(_test);
    args = new Argument();
    health.hurtSite = hurtSiteList[0]['code'];
    health.measure = hurtTypeList[0]['code'];
    health.memo = hurtTypeList[0]['name'];
    // health.hurt
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print('_test${_test.healthValue}');
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Column(children: [
          infoTitle('伤害'),
          RadioOptions(
            data: hurtTypeList,
            label: 'name',
            onValueChange: (_index) {
              this.setState(() {
                health.measure = hurtTypeList[_index]['code'];
                health.memo = hurtTypeList[_index]['code'];
              });
            },
          ),
          infoTitle('伤害地点'),
          RadioOptions(
            data: hurtSiteList,
            label: 'name',
            onValueChange: (_index) {
              this.setState(() {
                health.hurtSite = hurtSiteList[_index]['code'];
              });
            },
          ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 80.0),
            child: RaisedButton(
              onPressed: _onpress,
              child: Text('确认选择'),
            ),
          )
        ]),
      ),
    );
  }

  void _onpress() {
    final _profileNotify = Provider.of<ProfileNotify>(context, listen: false);

    args.params = health;

    _profileNotify.saveArg(args);
    Navigator.of(context).pop();
  }

  // Widget checkBoxItem(){
  //   return
  // }
  Widget infoTitle(String title) {
    return Container(
        color: Color(0xffe4e4e4),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Text(title));
  }
}
