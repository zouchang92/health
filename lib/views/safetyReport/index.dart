import 'package:date_format/date_format.dart';
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
  bool selfHasSubmit = true;
  final String noClassTip = '没有绑定班级';
  final String noBindTip = '没有绑定班级';
  @override
  void initState() {
    super.initState();
    // print('classStatus:${bindClass[0]['classId']}');
    heaSafety.classId = bindClass.length > 0 ? bindClass[0]['classId'] : '';
    heaSafety.className = bindClass.length > 0 ? bindClass[0]['className'] : '';
    heaSafety.total = bindClass.length > 0
        ? int.parse(bindClass[0]['totalNum']) ?? null
        : null;

    heaSafety.status = int.parse(classStatus[0]['code']);
    todayIsSub();
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
            child: Icon(Icons.history),
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
              child: selfHasSubmit
                  ? hasSubmit()
                  : ListView(children: <Widget>[form()]),
            )),
        Offstage(
          offstage: selfHasSubmit,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 100.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)),
              color: Color(0xff507cd7),
              onPressed: () {
                if (heaSafety.classId == null || heaSafety.classId == '') {
                  FLToast.info(text: noClassTip);
                } else {
                  _safetyReport();
                }
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
    List<Widget> _bindClass = [];
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
                todayIsSub();
                this.setState(() {
                  // print(bindClass[val]);

                  heaSafety.total = int.parse(bindClass[val]['totalNum']);
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
    // print('heaSafety:${heaSafety.toJson()}');
    await safetyReport(heaSafety);

    this.setState(() {
      selfHasSubmit = true;
    });
  }

  /*true时表示已提交*/
  Future todayIsSub() async {
    String date = formatDate(DateTime.now(), [yyyy, '-', mm, '-', dd]);
    var res = await safetyList(date, heaSafety.classId);
    print('dd');
    if (res != null && res['list'] != null) {
      this.setState(() {
        if (res['list'].length > 0) {
          //  bindClass[0]['stuNum']

          selfHasSubmit = true;
        } else {
          selfHasSubmit = false;
        }
      });
    }
  }
}
