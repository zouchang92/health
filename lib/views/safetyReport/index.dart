import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
import 'package:health/model/heaSafety.dart';
import 'package:health/service/index.dart';
import 'package:health/widget/index.dart';

class SafetyReport extends StatefulWidget {
  final String title = '平安上报';

  @override
  _SafetyReportState createState() => _SafetyReportState();
}

class _SafetyReportState extends State<SafetyReport> {
  HeaSafety heaSafety = new HeaSafety();
  List bindClass = Global.profile.user.classIdAndNames ?? [];
  List classStatus =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.CLASSSTATUS]);
  // GlobalKey _tabKey = new GlobalKey();
  GlobalKey _formKey = new GlobalKey();
  bool selfHasSubmit = false;
  @override
  void initState() {
    super.initState();
    print('classStatus:${todayIsSub()}');
    selfHasSubmit = todayIsSub();
    heaSafety.classId = bindClass.length > 0 ? bindClass[0]['classId'] : '';
    heaSafety.className = bindClass.length > 0 ? bindClass[0]['className'] : '';
    //  bindClass[0]['stuNum']
    heaSafety.total =
        bindClass.length > 0 ? bindClass[0]['stuNum'] ?? null : null;

    heaSafety.status = int.parse(classStatus[0]['code']);
  }

  @override
  Widget build(BuildContext context) {
    // print('hh:${_tabKey.currentContext}');
    return Scaffold(
      backgroundColor: Color(0xffeeeeee),
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          InkWell(
            child: Icon(Icons.list),
            onTap: () {
              Navigator.of(context).pushNamed('/safetyList');
            },
          )
        ],
      ),
      body: Column(children: <Widget>[
        tabbar(),
        // ListView(children: <Widget>[form()])
        Flexible(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(top: 20.0),
              color: Colors.white,
              child:selfHasSubmit?hasSubmit():ListView(children: <Widget>[form()]),
            )),
        Offstage(
          offstage: selfHasSubmit,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: RaisedButton(
              onPressed: () {
                _safetyReport();
              },
              child: Text('立即提交'),
            ),
          ),
        ),
      ]),
    );
  }

  Widget hasSubmit() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 60,
            backgroundColor: Color(0xffeceaf2),
            child: Icon(Icons.check, size: 80, color: Color(0xffae96bc)),
          ),
          Text('今日已提交',
              style: TextStyle(fontSize: 20, color: Color(0xff666666)))
        ],
      ),
    );
  }

  /*班级列表*/
  Widget tabbar() {
    
    List<Widget> _bindClass =
        bindClass.map((e) => tabbarItem(title: e['className'])).toList();
    return DefaultTabController(
        length: bindClass.length,
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
                  heaSafety.total = bindClass[val]['stuNum'];
                  heaSafety.classId = bindClass[val]['classId'];
                  heaSafety.className = bindClass[val]['className'];
                });
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

  /*form表单*/
  Widget form() {
    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
        ListTile(
          title: Text('总人数'),
          trailing: Text(heaSafety.total.toString() ?? '',
              style: TextStyle(color: Color(0xff666666))),
        ),
        Divider(height: 1),
        stepper(
            title: '出勤人数:',
            onChanged: (val) {
              // print(val);
              heaSafety.cqTotal = val;
            }),
        Divider(height: 1),
        stepper(
            title: '体温正常人数:',
            onChanged: (val) {
              // print(val);
              heaSafety.zcTotal = val;
            }),
        Divider(height: 1),
        stepper(
            title: '发热人数:',
            onChanged: (val) {
              // print(val);
              heaSafety.frTotal = val;
            }),
        Divider(height: 1),
        stepper(
            title: '伤害人数:',
            onChanged: (val) {
              // print(val);
              heaSafety.shTotal = val;
            }),
        Divider(height: 1),
        stepper(
            title: '病假人数:',
            onChanged: (val) {
              // print(val);
              heaSafety.qjTotal = val;
            }),
        Divider(height: 1),
        ListTile(
          title: Text('班级状态:'),
          trailing: RadioOptions(
            data: classStatus,
            label: 'name',
            onValueChange: (value) {
              heaSafety.status = int.parse(classStatus[value]['stuNum']);
            },
          ),
        )
      ]),
    );
  }

  Widget stepper({String title, Function onChanged}) {
    final FLCountStepperController _controller =
        FLCountStepperController(max: 10);
    return ListTile(
      title: Text(title),
      trailing: FLCountStepper(
        disableInput: false,
        controller: _controller,
        onChanged: onChanged,
      ),
    );
  }

  Future _safetyReport() async {
    

    await safetyReport(heaSafety);
    Global.profile.heaSafetySubTime = DateTime.now();
    Global.save();
    this.setState(() { 
      selfHasSubmit = todayIsSub();
    });
  }

  /*true时表示已提交*/
  bool todayIsSub() {
    DateTime markTime = Global.profile.heaSafetySubTime;
    if (markTime == null) {
      return false;
    } else {
      DateTime now = DateTime.now();
      DateTime nowStart = DateTime(now.year, now.month, now.day);
      DateTime nowEnd = DateTime(now.year, now.month, now.day, 24, 00);
      if (markTime.isAfter(nowStart) && markTime.isBefore(nowEnd)) {
        return true;
      } else {
        return false;
      }
      // now.isAtSameMomentAs(markTime);
    }
  }
}
