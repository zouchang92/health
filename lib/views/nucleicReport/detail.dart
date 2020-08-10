import 'package:flutter/material.dart';
import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
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
  void initState() {
    super.initState();
    //  参数已经传到了 Map类型-因为之前传来的就是Map
    print(widget.arg.params);
  }

  @override
  Widget build(BuildContext context) {
    var item = widget.arg.params;
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
          child: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 320.0, top: 10.0, bottom: 10.0),
          child: Text('第' + item['totalTimes'].toString() + '次检测'),
        ),
        Divider(
          height: 1,
          color: Color(0xff808080),
        ),
        Padding(
            padding: EdgeInsets.only(top: 0.0),
            child: Card(
              color: Color(0xffffffff),
              clipBehavior: Clip.antiAlias,
              child: Column(children: <Widget>[
                ListTile(
                  title: Text('姓名:'),
                  trailing: Text(item['name']),
                ),
                Divider(height: 1),
                ListTile(
                  title: Text('所护班级'),
                  trailing: Text(item['className']),
                ),
                Divider(height: 1),
                ListTile(
                  title: Text('igG'),
                  trailing: Text(Dictionary.getNameByUniqueNameAndCode(
                      uniqueName:
                          UniqueNameValues[UNIQUE_NAME.IGGMANDHSSSTATUS],
                      code: item['igG'])),
                ),
                Divider(height: 1),
                ListTile(
                  title: Text('igM'),
                  trailing: Text(Dictionary.getNameByUniqueNameAndCode(
                      uniqueName:
                          UniqueNameValues[UNIQUE_NAME.IGGMANDHSSSTATUS],
                      code: item['igM'])),
                ),
                Divider(height: 1),
                ListTile(
                  title: Text('核酸'),
                  trailing: Text(Dictionary.getNameByUniqueNameAndCode(
                      uniqueName:
                          UniqueNameValues[UNIQUE_NAME.IGGMANDHSSSTATUS],
                      code: item['hs'])),
                ),
                Divider(height: 1),
                ListTile(
                  title: Text('检测结论'),
                  trailing: Text(Dictionary.getNameByUniqueNameAndCode(
                      uniqueName: UniqueNameValues[UNIQUE_NAME.CHECKRESULTS],
                      code: (item['checkResult']))),
                ),
                Divider(height: 1),
                ListTile(
                  title: Text('检测报告书'),
                ),
                Padding(
                    padding:
                        EdgeInsets.only(right: 230.0, top: 0.0, bottom: 20.0),
                    child: Image(
                        image:
                            NetworkImage(Global.getHttpPicUrl(item['report'])),
                        width: 200.0,
                        height: 200.0)),
              ]),
            ))
      ])),
    );
  }
}
