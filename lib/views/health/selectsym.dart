import 'package:flutter/material.dart';

import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/health.dart';
import 'package:health/store/profileNotify.dart';
import 'package:health/widget/checkBoxGroup/index.dart';

import 'package:provider/provider.dart';

class SelectSym extends StatefulWidget {
  final String title = '症状选择';
  @override
  _SelectSymState createState() => _SelectSymState();
}

class _SelectSymState extends State<SelectSym> {
  List symTypeList =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.SYMPTOMTYPE]);
  /*赋值对象*/
  Argument args;
  Health health = new Health();
  List<String> selected = [];
  @override
  void initState() {
    args = new Argument();
    health.symptomTypeValue = symTypeList[0]['name'];
    health.symptomType = symTypeList[0]['code'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          CheckBoxGroup(
            data: symTypeList,
            label: 'name',
            onValueChange: (selected) {
              print('selected:$selected');
              health.symptomTypeMulti =
                  selected.map((e) => e['code'] as String).toList();
              health.symptomTypeMultiValue =
                  selected.map((e) => e['name'] as String).toList();
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
}
