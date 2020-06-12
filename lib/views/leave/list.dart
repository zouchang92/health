
import 'package:flutter/material.dart';


class LeaveList extends StatefulWidget {
  final String title = '学生请假';
  @override
  _LeaveListState createState() => _LeaveListState();
}

class _LeaveListState extends State<LeaveList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List bindClass = [
    {"name": '待处理', "id": '1'},
    {"name": '未处理', "id": '2'}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text(widget.title)),
      body: Column(
        children: <Widget>[
          tabbar()
        ],
      ),
    );
  }
  Widget tabbar() {
    // _tabController = TabController(length: bindClass.length, vsync: this);
    List<Widget> _bindClass =
        bindClass.map((e) => tabbarItem(title: e['name'])).toList();
    return DefaultTabController(
        length: _bindClass.length,
        initialIndex: 0,
        child: Container(
            color: Colors.white,
            width: double.infinity,
            // alignment: Align,
            child: TabBar(
              // key: _tabKey,
              labelColor: Colors.black,
              labelStyle: TextStyle(color: Colors.blue),
              tabs: _bindClass,
              isScrollable: true,
            )));
  }
  Widget tabbarItem({String title}) {
    return Tab(
      // padding: EdgeInsets.symmetric(vertical: 10.0),
      text: title,
      // child: Row(children:[Text(title)]),
      
    );
  }
  
}