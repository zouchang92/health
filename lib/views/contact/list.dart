import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:health/model/argument.dart';
import 'package:health/model/health.dart';
import 'package:health/model/pagination.dart';
import 'package:health/model/student.dart';
import 'package:health/service/index.dart';
import 'package:health/store/profileNotify.dart';
import 'package:provider/provider.dart';

class ContactList extends StatefulWidget {
  final String title = '选择学生';
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List studentList = [];
  Widget stuWidgetList;
  int selected;
  bool showFloatButton = false;
  Argument args;
  Health health = new Health();
  Student stu = Student(organId: 'RSFUBDUHPHCKPWXANVMWJHPTRXCYAWZC');
  Pagination pagination = Pagination(page: 1, rows: 10);
  ScrollController scrollController = ScrollController();
  bool firstLoading = true;
  bool loading = true;
  
  @override
  void initState() {
    super.initState();
    selected = 0;
    args = new Argument();

    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // print('滑动到了最底部${scrollController.position.pixels}');
        pullPagination();
      }
    });
    
    _getStudentList();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }
  
  
  @override
  Widget build(BuildContext context) {
    // RefreshIndicator(child: list(context), onRefresh: _push)
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {})
        ],
      ),
      body: firstLoading?loadingWidget():RefreshIndicator(child: list(context), onRefresh: _push),
      floatingActionButton:
          FloatingActionButton(onPressed: _onpress, child: Text('确认')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget loadingWidget() {
    return Center(
      child: Container(
          height: 100.0,
          width: 100.0,
          child: CircularProgressIndicator(
            strokeWidth: 14.0,
            backgroundColor: Colors.blue,
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.red),
          )),
    );
  }

  Widget list(BuildContext context) {
    return ListView.builder(
        controller: scrollController,
        itemCount: studentList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(children: <Widget>[
            RadioListTile(
              title: Text(studentList[index]['studentName'] ?? ''),
              value: index,
              groupValue: selected,
              onChanged: (_index) {
                //  print('_index:$_index');
                this.setState(() {
                  this.selected = _index;
                  health.stuNum = studentList[_index]['studentNum'];
                  health.stuNumValue = studentList[_index]['studentName'];
                });
              },
            ),
            index == studentList.length - 1
                ? Container(height: 0, width: 0)
                : Divider(height: 1)
          ]);
        });
  }

  void _onpress() {
    final _profileNotify = Provider.of<ProfileNotify>(context, listen: false);

    args.params = health;

    _profileNotify.saveArg(args);
    Navigator.of(context).pop();
  }

  void pullPagination() {
    this.setState(() {
      if (pagination.pageSize == pagination.totalCount) {
        this.pagination.page += 1;
        _getStudentList();
      }
    });
  }

  Future _push() async {
    this.setState(() {
      pagination.page = 1;
    });
    var res = await getStudentList(stu: stu, pagination: pagination);
    this.setState(() {
      studentList = res['list'];
      if (studentList.length > 0) {
        health.stuNum = studentList[0]['studentNum'];
        health.stuNumValue = studentList[0]['studentName'];
      }
      pagination.totalCount = res['totalCount'];
      pagination.pageSize = res['totalCount'];
    });
  }

  Future _getStudentList() async {
    //  Student stu = Student(organId:'RSFUBDUHPHCKPWXANVMWJHPTRXCYAWZC');
    
    var res = await getStudentList(stu: stu, pagination: pagination);
    //  print('res$res');
    
    this.setState(() {
      
      this.firstLoading = false;
      // studentList = res['list'];
      studentList.addAll(res['list']);
      // print('studentList:$studentList');
      if (studentList.length > 0) {
        health.stuNum = studentList[0]['studentNum'];
        health.stuNumValue = studentList[0]['studentName'];
      }
      pagination.totalCount = res['totalCount'];
      pagination.pageSize = res['totalCount'];

      // this.stuWidgetList = list(context,stuList: res['list']);
    });
  }
}
