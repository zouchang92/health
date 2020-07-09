import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
import 'package:health/model/heaSafety.dart';
import 'package:health/service/index.dart';

class SafetyList extends StatefulWidget {
  final String title = '平安上报历史';

  @override
  _SafetyListState createState() => _SafetyListState();
}

class _SafetyListState extends State<SafetyList> {
  HeaSafety heaSafety = new HeaSafety();
  List bindClass = Global.profile.user.classIdAndNames ?? [];
  final String noBindTip = '没有绑定班级';
  String classId;
  String date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
  @override
  void initState() {
    super.initState();
    classId = bindClass.length > 0 ? bindClass[0]['classId'] : '';
    _safetyList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            tabbar(),
            CalendarDatePicker(
                initialDate: DateTime.now(),
                firstDate: DateTime.now().subtract(Duration(days: 30)),
                lastDate: DateTime.now(),
                onDateChanged: (dateTime) {
                  this.setState(() {
                    date = formatDate(dateTime, [yyyy, '-', mm, '-', dd]);
                  });
                  _safetyList();
                }),
            heaSafety.status == null ? empty() : form()
          ],
        ),
      ),
    );
  }

  Widget empty() {
    return Center(
      child: Text('--未提交数据--', style: TextStyle(color: Color(0xff666666))),
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
        trailing: Chip(
            label: Text(Dictionary.getNameByUniqueNameAndCode(
                uniqueName: UniqueNameValues[UNIQUE_NAME.CLASSSTATUS],
                code: heaSafety.status?.toString()))),
      )
    ]);
  }

  /*班级列表*/
  Widget tabbar() {
    List<Widget> _bindClass;
    if (bindClass.length == 0) {
      _bindClass = [tabbarItem(title: noBindTip)];
    } else {
      _bindClass =
          bindClass.map((e) => tabbarItem(title: e['className'])).toList();
    }
    return DefaultTabController(
        length: _bindClass.length,
        initialIndex: 0,
        child: Container(
            width: double.infinity,
            color: Colors.white,
            child: TabBar(
              // key: _tabKey,
              labelColor: Colors.black,
              labelStyle: TextStyle(color: Colors.blue),
              tabs: _bindClass,
              isScrollable: true,
              onTap: (int val) {
                this.setState(() {
                  classId = bindClass[val]['classId'];
                });
                _safetyList();
              },
            )));
  }

  /*tabbarItem*/
  Widget tabbarItem({String title}) {
    return Tab(
      // padding: EdgeInsets.symmetric(vertical: 10.0),
      text: title ?? '',
    );
  }

  Future _safetyList() async {
    var res = await safetyList(date, classId);

    if (res != null && res['list'] != null) {
      this.setState(() {
        if (res['list'].length > 0) {
          print(res['list'][0]);
          heaSafety = HeaSafety.fromJson(res['list'][0]);
        } else {
          heaSafety = new HeaSafety();
        }
      });
    }
  }
}
