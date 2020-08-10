// import 'package:dio/dio.dart';
import 'package:date_format/date_format.dart';
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
  List igg = Dictionary.getByUniqueName(
      UniqueNameValues[UNIQUE_NAME.IGGMANDHSSSTATUS]);
  bool empty = false;
  bool firstLoading = true;
  List dataList = [];

  @override
  void initState() {
    super.initState();
    //  参数已经传到了 Map类型-因为之前传来的就是Map
    print(widget.args.params);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(child: listItem(widget.args.params)),
    );
  }

  Widget listItem(Map item) {
    print('我想看看');
    print(item);
    return InkWell(
      child: Card(
        color: Color(0xffae96bc),
        margin: EdgeInsets.all(15.0),
        clipBehavior: Clip.antiAlias,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: cardContent(item),
      ),
      onTap: () {
        Navigator.of(context)
            .pushNamed('/nuclecDetail', arguments: Argument(params: item));
      },
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
                      Text('姓名:', style: TextStyle(color: Colors.white)),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          item['name'],
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  children: <Widget>[
                    Row(children: <Widget>[
                      Text('班级信息:', style: TextStyle(color: Colors.white)),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(item['className'] ?? '',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ]),
                    Row(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text('检测日期:',
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0, top: 10.0),
                        child: Text(
                            item['createTime'] != null
                                ? formatTime(item['createTime'])
                                : '',
                            style: TextStyle(color: Colors.white)),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 100.0, top: 10.0),
                        child: Text(
                          '第' + item['totalTimes'].toString() + '次检测',
                          style: TextStyle(fontSize: 15.0, color: Colors.white),
                        ),
                      ),
                    ]),
                    Divider(height: 1, color: Colors.white),
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Text('igG:',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0))),
                        Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 15.0),
                            child: Text(
                                Dictionary.getNameByUniqueNameAndCode(
                                    uniqueName: UniqueNameValues[
                                        UNIQUE_NAME.IGGMANDHSSSTATUS],
                                    code: item['igG']),
                                style: TextStyle(color: Colors.white))),
                        Padding(
                          padding: EdgeInsets.only(top: 15.0, left: 140.0),
                          child: Text('igM:',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18.0)),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Text(
                                Dictionary.getNameByUniqueNameAndCode(
                                    uniqueName: UniqueNameValues[
                                        UNIQUE_NAME.IGGMANDHSSSTATUS],
                                    code: item['igM']),
                                style: TextStyle(color: Colors.white))),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(top: 15.0),
                            child: Text('核酸:',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0))),
                        Padding(
                            padding: EdgeInsets.only(left: 10.0, top: 15.0),
                            child: Text(
                                Dictionary.getNameByUniqueNameAndCode(
                                    uniqueName: UniqueNameValues[
                                        UNIQUE_NAME.IGGMANDHSSSTATUS],
                                    code: item['hs']),
                                style: TextStyle(color: Colors.white))),
                      ],
                    )
                  ],
                ),
              )
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

  String formatTime(String str) {
    return formatDate(DateTime.parse(str), [
      yyyy,
      '-',
      mm,
      '-',
      dd,
      ' ',
    ]);
  }

  String ynLabel(String code) {
    return Dictionary.getNameByUniqueNameAndCode(
        uniqueName: UniqueNameValues[UNIQUE_NAME.BOOLEAN], code: code);
  }
}
