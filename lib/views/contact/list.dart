import 'package:flutter/material.dart';
import 'package:health/model/argument.dart';
import 'package:health/model/health.dart';
import 'package:health/model/pagination.dart';
import 'package:health/model/student.dart';
import 'package:health/service/index.dart';
import 'package:health/store/profileNotify.dart';
import 'package:provider/provider.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

class ContactList extends StatefulWidget {
  final String title = '选择学生';
  final Argument argument;
  ContactList({this.argument});
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final AppBarController appBarController = AppBarController();
  List studentList = [];
  Widget stuWidgetList;
  int selected;
  bool showFloatButton = false;
  Argument args = new Argument();
  Health health = new Health();
  Student stu;
  Pagination pagination = Pagination(page: 1, rows: 10);
  ScrollController scrollController = ScrollController();
  bool firstLoading = true;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    selected = 0;
    // print('widget:${widget.argument}');
    stu = Student(organId: widget.argument.params);
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
    return Scaffold(
      appBar: SearchAppBar(
          appBarController: appBarController,
          primary: Theme.of(context).primaryColor,
          searchHint: '输入姓名',
          onChange: (String value) {
            if (value != '') {
              //  print(value == '');
              this.setState(() {
                health.name = value;
                pagination.page = 1;
                studentList = [];
              });
              _getStudentList();
            }
          },
          mainAppBar: AppBar(
            title: Text(widget.title),
            actions: <Widget>[
              InkWell(
                  child: Icon(Icons.search),
                  onTap: () {
                    appBarController.stream.add(true);
                  })
            ],
          )),
      body: content(),
      floatingActionButton:
          FloatingActionButton(onPressed: _onpress, child: Text('确认')),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget content() {
    if (firstLoading == true) {
      return Center(child: Text('加载中...'));
    } else {
      if (studentList.length == 0) {
        return Center(child: Text('--没有数据--'));
      } else {
        return RefreshIndicator(child: list(context), onRefresh: _push);
      }
    }
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
                print('_index:${studentList[_index]}');
                this.setState(() {
                  this.selected = _index;
                  health.id = studentList[index]['id'];
                  health.stuNum = studentList[_index]['studentNum'];
                  health.stuNumValue = studentList[_index]['studentName'];
                  health.schoolName = studentList[_index]['schoolName'];
                  health.school = studentList[_index]['school'];
                  health.province = studentList[_index]['province'];
                  health.provinceName = studentList[_index]['provinceName'];
                  health.name = studentList[_index]['studentName'];
                  // health.personType = studentList[0]['personType'];
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
      if (res != null) {
        studentList = res['list'];

        if (studentList.length > 0) {
          health.stuNum = studentList[0]['studentNum'];
          health.stuNumValue = studentList[0]['studentName'];
          health.schoolName = studentList[0]['schoolName'];
          health.school = studentList[0]['school'];
          health.province = studentList[0]['province'];
          health.provinceName = studentList[0]['provinceName'];
          health.name = studentList[0]['studentName'];
          // health.personType = studentList[0]['personType'];
        }
        pagination.totalCount = res['totalCount'];
        pagination.pageSize = res['totalCount'];
      }
    });
  }

  Future _getStudentList() async {
    //  Student stu = Student(organId:'RSFUBDUHPHCKPWXANVMWJHPTRXCYAWZC');

    var res = await getStudentList(stu: stu, pagination: pagination);
    print('res$res');

    this.setState(() {
      this.firstLoading = false;
      // studentList = res['list'];
      if (res != null) {
        studentList.addAll(res['list']);
        // print('studentList:$studentList');
        if (studentList.length > 0) {
          health.stuNum = studentList[0]['studentNum'];
          health.stuNumValue = studentList[0]['studentName'];
          health.schoolName = studentList[0]['schoolName'];
          health.school = studentList[0]['school'];
          health.province = studentList[0]['province'];
          health.provinceName = studentList[0]['provinceName'];
          health.name = studentList[0]['studentName'];
          // health.personType = studentList[0]['personType'];
        }
        pagination.totalCount = res['totalCount'];
        pagination.pageSize = res['totalCount'];
      }
    });
  }
}
