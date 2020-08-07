import 'package:flutter/material.dart';
import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/nuclecReport.dart';

class NucleicDetail extends StatefulWidget {
  final String title = '查看详情';
  final Argument arg;
  NucleicDetail({this.arg});
  @override
  _NucleicDetailState createState() => _NucleicDetailState();
}

class _NucleicDetailState extends State<NucleicDetail> {
  @override
  Widget build(BuildContext context) {
    Argument arg = ModalRoute.of(context).settings.arguments;
    NuclecReport nucleicReport = NuclecReport.fromJson(arg.params);
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: SingleChildScrollView(
            child: Column(children: <Widget>[
          ListTile(
            title: Text('姓名:'),
            trailing: Text(nucleicReport.name ?? ''),
          ),
        ])));
  }

  String ynLabel(String code) {
    return Dictionary.getNameByUniqueNameAndCode(
        uniqueName: UniqueNameValues[UNIQUE_NAME.BOOLEAN], code: code);
  }

  String symLabel(List<String> list) {
    //  List<String> list = sym.split(',');
    return list
        .map((e) => Dictionary.getNameByUniqueNameAndCode(
            uniqueName: UniqueNameValues[UNIQUE_NAME.SYMPTOMTYPE], code: e))
        .toList()
        .join(',');
    //
  }

  Widget infoTitle(String title) {
    return Container(
        color: Color(0xffe4e4e4),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Text(title));
  }

  String getTypeValue(code) {
    var item = Dictionary.getNameByUniqueNameAndCode(
        uniqueName: UniqueNameValues[UNIQUE_NAME.ILLTYPE], code: code);
    return '$item信息';
  }
}
