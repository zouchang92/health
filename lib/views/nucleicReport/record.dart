import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
import 'package:health/model/nuclecReport.dart';
import 'package:health/model/user.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

class NucleicRecord extends StatefulWidget {
  final String title = '监测记录';
  final Argument args;
  NucleicRecord({this.args});
  @override
  _NucleicRecordState createState() => _NucleicRecordState();
}

class _NucleicRecordState extends State<NucleicRecord> {
  final _formKey = GlobalKey<FormState>();
  final User user = Global.profile.user;
  NuclecReport nuclecReport = new NuclecReport();
  final AppBarController appBarController = AppBarController();
  final ScrollController scrollController = ScrollController();
  List yn = Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.BOOLEAN]);
  bool empty = false;
  bool firstLoading = true;
  List dataList = [];

  @override
  void initState() {
    super.initState();
    Map item = new Map<String, dynamic>.from(widget.args.params);
    nuclecReport = item as NuclecReport;
    print(nuclecReport);
  }

  // @override
  // Widget build(BuildContext context) {
  //   Argument args = ModalRoute.of(context).settings.arguments;
  //   Map item = new Map<String, dynamic>.from(args.params);
  //   // print(item);
  //   return Scaffold(
  //     appBar: AppBar(title: Text(widget.title)),
  //     body: SingleChildScrollView(
  //       child: Column(children: <Widget>[]),
  //     ),
  //   );
  // }

  Widget listItem(nuclecReport) {
    return InkWell(
      child: Card(
        color: Color(0xffae96bc),
        margin: EdgeInsets.all(15.0),
        clipBehavior: Clip.antiAlias,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: cardContent(nuclecReport),
        // child: Text('123'),
      ),
      onTap: () {},
    );
  }

  Widget cardContent(item) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Stack(
                  alignment: FractionalOffset(1, 0.6),
                  children: <Widget>[
                    Row(children: <Widget>[
                      Text('姓名:'),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text('123'),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(
          height: 1,
          color: Colors.white,
        ),
      ],
    );
  }

  String statusLabel(String code) {
    return Dictionary.getNameByUniqueNameAndCode(
        uniqueName: UniqueNameValues[UNIQUE_NAME.HEASTATUS], code: code);
  }

  // 64a247 a26b47 4747a2 47a25d 5c47a2
  Color statusColor(String status) {
    switch (status) {
      case '1':
        return Color(0xffff0079);
      case '2':
        return Color(0xff64a247);
      case '3':
        return Color(0xffa26b47);
      case '4':
        return Color(0xff4747a2);
      case '5':
        return Color(0xff47a25d);
      case '6':
        return Color(0xff3ab25d);
      case '7':
        return Color(0xff5c47a2);
      default:
        return Colors.grey;
    }
  }

  Future _push() async {
    this.setState(() {
      dataList = widget.args.params;
      print(dataList);
      // pagination.totalCount = res['totalCount'];
      // pagination.pageSize = res['totalCount'];
    });
  }

  String ynLabel(String code) {
    return Dictionary.getNameByUniqueNameAndCode(
        uniqueName: UniqueNameValues[UNIQUE_NAME.BOOLEAN], code: code);
  }
}
