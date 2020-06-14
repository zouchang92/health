import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/widget/index.dart';

class SafetyReport extends StatefulWidget {
  final String title = '平安上报';

  @override
  _SafetyReportState createState() => _SafetyReportState();
}

class _SafetyReportState extends State<SafetyReport> {
  
  List bindClass = [
    {"name": '高三（2）班', "picUrl": 'images/icon/menu_icon_3.png'},
    {"name": '高三（2）班', "picUrl": 'images/icon/menu_icon_3.png'},
    // {"name": '高三（2）班', "picUrl": 'images/icon/menu_icon_3.png'},
    // {"name": '高三（2）班', "picUrl": 'images/icon/menu_icon_3.png'}
  ];
  List classStatus = Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.CLASSSTATUS]);
  // GlobalKey _tabKey = new GlobalKey();
  GlobalKey _formKey = new GlobalKey();
  @override
  void initState() {
    
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    // print('hh:${_tabKey.currentContext}');
    return Scaffold(
      backgroundColor: Color(0xffeeeeee),
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[Icon(Icons.refresh)],
      ),
      body: Column(children: <Widget>[
        tabbar(),
        Flexible(
            flex: 1,
            child: Container(
              margin: EdgeInsets.only(top: 20.0),
              color: Colors.white,
              child: ListView(children: <Widget>[form()]),
            )),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: RaisedButton(
            onPressed: () {},
            child: Text('立即提交'),
          ),
        )
      ]),
    );
  }

  /*班级列表*/
  Widget tabbar() {
    // _tabController = TabController(length: bindClass.length, vsync: this);
    List<Widget> _bindClass =
        bindClass.map((e) => tabbarItem(title: e['name'])).toList();
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
            )));
  }

  /*tabbarItem*/
  Widget tabbarItem({String title}) {
    return Tab(
      // padding: EdgeInsets.symmetric(vertical: 10.0),
      text: title,
      icon: Image.asset('images/icon/menu_icon_3.png'),
    );
  }

  /*form表单*/
  Widget form() {
    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
        ListTile(
          title: Text('总人数'),
          trailing: Text('2',style: TextStyle(color:Color(0xff666666))),
        ),
        Divider(height: 1),
        stepper(title: '出勤人数:',onChanged: (val){
          print(val);
        }),
        Divider(height: 1),
        stepper(title: '体温正常人数:',onChanged: (val){
          print(val);
        }),
        Divider(height: 1),
        stepper(title: '发热人数:',onChanged: (val){
          print(val);
        }),
        Divider(height: 1),
        stepper(title: '伤害人数:',onChanged: (val){
          print(val);
        }),
        Divider(height: 1),
        stepper(title: '病假人数:',onChanged: (val){
          print(val);
        }),
        Divider(height:1),
        ListTile(
          title: Text('班级状态:'),
          trailing: RadioOptions(
            data: classStatus,
            label: 'name',
            onValueChange:(value){

            },
            
          ),
        )

      ]),
    );
  }

  Widget stepper({String title,Function onChanged}){
   final FLCountStepperController _controller = FLCountStepperController(max: 10);
   return ListTile(
     title: Text(title),
     trailing: FLCountStepper(
       disableInput: false,
       controller: _controller,
       onChanged:onChanged,
    ),
   );
  }
}
