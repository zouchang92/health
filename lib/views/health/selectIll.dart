import 'package:flutter/material.dart';
import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/health.dart';
import 'package:health/store/profileNotify.dart';
import 'package:health/widget/index.dart';
import 'package:provider/provider.dart';

class SelectIll extends StatefulWidget {
  final String title = '传染病选择';
  @override
  _SelectIllState createState() => _SelectIllState();
}

class _SelectIllState extends State<SelectIll> {
  List infectionList =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.INFECTIONTYPE]);
  // int buttonDisabled = -1;
  /*赋值对象*/
  Argument args;
  Health _health = new Health();
  // Map temArg = {};
  @override
  void initState() {
    args = new Argument();
    // temArg[UNIQUE_NAME.INFECTIONTYPE] = infectionList[0];
    _health.infectionType = infectionList[0]['code'];
    _health.memo = infectionList[0]['name'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          RadioOptions(
            data: infectionList,
            label: 'name',
            onValueChange: (_index) {
              this.setState(() {
                // temArg[UNIQUE_NAME.INFECTIONTYPE] = infectionList[_index];
                _health.infectionType = infectionList[_index]['code'];
                _health.memo = infectionList[_index]['name'];
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
        ],
      )),
    );
  }

  void _onpress() {
    final _profileNotify = Provider.of<ProfileNotify>(context, listen: false);

    args.params = _health;

    _profileNotify.saveArg(args);
    Navigator.of(context).pop();
  }
}
