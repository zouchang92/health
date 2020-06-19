import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/heaSafety.dart';
import 'package:health/service/index.dart';

class SafetyList extends StatefulWidget {
  final String title = '平安上报历史';
  @override
  _SafetyListState createState() => _SafetyListState();
}

class _SafetyListState extends State<SafetyList> {
  HeaSafety heaSafety = new HeaSafety();
  @override
  void initState() {
    super.initState();

    _safetyList(formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(Duration(days: 30)),
                lastDate: DateTime.now(),
                onDateChanged: (dateTime) {
                  // print('dateTime:$dateTime');
                  _safetyList(formatDate(dateTime, [yyyy, '-', mm, '-', dd]));
                }),
            // form()
            // empty()
            // Column()
            heaSafety.status==null?empty():form()
          ],
        ),
      ),
    );
  }
  Widget empty(){
    return Center(
      child: Text('--未提交数据--',style: TextStyle(color:Color(0xff666666))),
    );
  }

  Widget form() {
    return Column(children: <Widget>[
      ListTile(
        title: Text('班级:'),
        trailing: Text(heaSafety.className ?? '',
            style: TextStyle(color: Color(0xff666666))),
      ),
      Divider(height: 1),
      ListTile(
        title: Text('总人数:'),
        trailing: Text(heaSafety.total.toString() ?? '',
            style: TextStyle(color: Color(0xff666666))),
      ),
      Divider(height: 1),
      ListTile(
        title: Text('体温正常人数'),
        trailing: Text(heaSafety.zcTotal.toString()),
      ),
      Divider(height: 1),
      ListTile(
        title: Text('发热人数'),
        trailing: Text(heaSafety.frTotal.toString()),
      ),
      Divider(height: 1),
      ListTile(
        title: Text('伤害人数'),
        trailing: Text(heaSafety.shTotal.toString()),
      ),
      Divider(height: 1),
      ListTile(
        title: Text('病假人数'),
        trailing: Text(heaSafety.qjTotal.toString()),
      ),
      Divider(height: 1),

      // Divider(height: 1),
      ListTile(
        title: Text('班级状态:'),
        trailing: Chip(label: Text(Dictionary.getNameByUniqueNameAndCode(
          uniqueName: UniqueNameValues[UNIQUE_NAME.CLASSSTATUS],
          code: heaSafety.status?.toString()
        ))),
      )
    ]);
  }

  Future _safetyList(String date) async {
    var res = await safetyList(date);

    if (res != null && res['list'] != null) {
      this.setState(() {
        if (res['list'].length > 0) {
          print(res['list'][0]);
          heaSafety = HeaSafety.fromJson(res['list'][0]);
        }else{
          heaSafety = new HeaSafety();
        }
      });
    }
  }
}
