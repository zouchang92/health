import 'package:flui/flui.dart';
import 'package:flutter/material.dart';

class SafetyReport extends StatefulWidget {
  String title = '平安上报';
  @override
  _SafetyReportState createState() => _SafetyReportState();
}

class _SafetyReportState extends State<SafetyReport> {
  List bindClass = [
    {"name": '高三（2）班', "picUrl": 'images/icon/menu_icon_3.png'},
    {"name": '高三（2）班', "picUrl": 'images/icon/menu_icon_3.png'},
    {"name": '高三（2）班', "picUrl": 'images/icon/menu_icon_3.png'},
    {"name": '高三（2）班', "picUrl": 'images/icon/menu_icon_3.png'}
  ];
  // GlobalKey _tabKey = new GlobalKey();
  GlobalKey _formKey = new GlobalKey();

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
              margin: EdgeInsets.only(top:20.0),
              color: Colors.white,
              child: ListView(children: <Widget>[form()]),
            )),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: RaisedButton(
            onPressed: () {},
            child: Text('提交'),
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
        FLAutoComplete(
          itemBuilder: (context, suggestion) => Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(title: Text(suggestion)),
          ),
          child: TextFormField(),
        )
      ]),
    );
  }
}
