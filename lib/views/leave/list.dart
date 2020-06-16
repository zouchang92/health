import 'package:flutter/material.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
import 'package:health/model/pagination.dart';
import 'package:health/service/index.dart';

class LeaveList extends StatefulWidget {
  final String title = '学生请假';
  @override
  _LeaveListState createState() => _LeaveListState();
}

class _LeaveListState extends State<LeaveList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  Pagination pagination = Pagination(page: 1, rows: 10);
  List bindClass = [
    {"name": '待处理', "id": '1'},
    {"name": '未处理', "id": '2'}
  ];
  bool loading = true;
  List dataList = [];
  @override
  void initState() {
    super.initState();
    _getLeaveList();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // print('滑动到了最底部${scrollController.position.pixels}');
        this.pagination.page += 1;
        if (pagination.pageSize == pagination.totalCount) {
          this.pagination.page += 1;
          _getLeaveList();
        }
      }
    });
  }
  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(widget.title)),
      body: RefreshIndicator(
          child: pageList(),
          onRefresh: () {
            this.setState(() {
              pagination.page = 1;
              dataList = [];
            });
          }),
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

  Widget pageList() {
    if (loading) {
      return Center(
        child: Text('加载中...'),
      );
    } else {
      if (dataList.length == 0) {
        return Center(
          child: Text('--无数据--'),
        );
      } else {
        return ListView.builder(
          controller: scrollController,
          itemBuilder: (context, _index) {
            return Card(
              color: Color(0xffae96bc),
              margin: EdgeInsets.all(15.0),
              clipBehavior: Clip.antiAlias,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              child: cardContent(dataList[_index] as Map),
            );
          },
          itemCount: dataList.length,
        );
      }
    }
  }

  Widget cardContent(Map item) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Stack(
                  alignment: FractionalOffset(1, 0.9),
                  children: <Widget>[
                    Row(children: <Widget>[
                      CircleAvatar(
                          // radius: 35.0,
                          backgroundColor: Color(0xffe3dfeb),
                          backgroundImage: AssetImage('images/upload_bg.png')),
                      Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(item['name'] ?? '',
                              style: TextStyle(color: Colors.white))),
                    ]),
                    // Chip(
                    //     backgroundColor: Color(0xffff0079),
                    //     label:
                    //         Text('未复课', style: TextStyle(color: Colors.white)))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Column(
                  children: <Widget>[
                    Row(children: <Widget>[
                      Text('班级信息:', style: TextStyle(color: Colors.white)),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(item['className'] ?? '',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ]),
                    Row(children: <Widget>[
                      Text('离校日期:', style: TextStyle(color: Colors.white)),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(item['leaveDate'] ?? '',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ]),
                    Row(children: <Widget>[
                      Text('登记类型:', style: TextStyle(color: Colors.white)),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Chip(
                            backgroundColor: Color(0xffff6000),
                            label: Text(
                                Dictionary.getNameByUniqueNameAndCode(
                                    uniqueName: UniqueNameValues[
                                        UNIQUE_NAME.REGISTERTYPE],
                                    code: item['registerType']),
                                style: TextStyle(color: Colors.white))),
                      ),
                    ])
                  ],
                ),
              )
            ],
          ),
        ),
        Divider(
          height: 1,
          color: Colors.white,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Text('复课时间:', style: TextStyle(color: Colors.white)),
                      Text(item['healDate'] ?? '',
                          style: TextStyle(color: Colors.white))
                    ]),
                // Chip(
                //   backgroundColor: Color(0xff0099db),
                //   label: Text('复课', style: TextStyle(color: Colors.white)),
                //   // onDeleted: () {
                //   //   _healthDelete(item['id']);
                //   // },
                // )
              ]),
        )
      ],
    );
  }
  // Future _refresh() async{

  // }
  Future _getLeaveList() async {
    var res =
        await getLeaveList(pagination: pagination, user: Global.profile.user);
    print('res:$res');
    this.setState(() {
      loading = false;
    });
    if (res != null) {
      if (res['list'].length > 0) {
        this.setState(() {
          //  dataList = res['list'];
          dataList.addAll(res['list']);
          pagination.totalCount = res['totalCount'];
          pagination.pageSize = res['totalCount'];
        });
      }
    }
  }
}
