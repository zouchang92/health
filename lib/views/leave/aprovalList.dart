import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
import 'package:health/model/pagination.dart';
import 'package:health/service/index.dart';

class LeaveApprovalList extends StatefulWidget {
  final title = '学生请假';
  @override
  _LeaveApprovalListState createState() => _LeaveApprovalListState();
}

class _LeaveApprovalListState extends State<LeaveApprovalList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  Pagination pagination = Pagination(page: 1, rows: 10);
  String status;
  // dealCode
  List bindClass =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.JUDGESTATUS]);
  bool loading = true;
  List dataList = [];

  @override
  void initState() {
    super.initState();
    status = bindClass[0]['code'];
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
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/LeaveApplyForStudent');
            },
            child: Icon(Icons.add_circle_outline),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          tabbar(),
          Flexible(
              flex: 1,
              child: RefreshIndicator(
                  child: pageList(),
                  onRefresh: () {
                    this.setState(() {
                      pagination.page = 1;
                      dataList = [];
                    });
                    return _getLeaveList();
                  }))
        ],
      ),
    );
  }

  Widget tabbar() {
    // _tabController = TabController(length: bindClass.length, vsync: this);
    // print(MediaQuery.of(context));
    List<Widget> _bindClass =
        bindClass.map((e) => tabbarItem(title: e['name'])).toList();
    return DefaultTabController(
        length: _bindClass.length,
        initialIndex: 0,
        child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            // alignment: Align,
            child: TabBar(
              labelPadding: EdgeInsets.all(0),
              // key: _tabKey,
              labelColor: Colors.black,
              labelStyle: TextStyle(color: Colors.blue),
              tabs: _bindClass,
              isScrollable: true,
              onTap: (_index) {
                this.setState(() {
                  status = bindClass[_index]['code'];
                  pagination.page = 1;
                  dataList = [];
                });
                _getLeaveList();
              },
            )));
  }

  Widget tabbarItem({String title}) {
    return Tab(
      iconMargin: EdgeInsets.all(0),
      // text: title,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / bindClass.length,
        child: Text(title),
      ),
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
              color: Color(0xffffffff),
              margin: EdgeInsets.all(8.0),
              clipBehavior: Clip.antiAlias,
              // elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0.0))),
              child: cardContent(dataList[_index] as Map),
            );
          },
          itemCount: dataList.length,
        );
      }
    }
  }

  Widget cardContent(Map item) {
    print('item:$item');
    return Column(
      children: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(context)
                .pushNamed('/leaveDateil', arguments: Argument(params: item));
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Stack(
              children: <Widget>[
                Container(
                  height: 120.0,
                ),
                Positioned(
                    left: 10.0,
                    top: 10.0,
                    child: CircleAvatar(
                        radius: 27.0,
                        backgroundColor: Color(0xffe3dfeb),
                        backgroundImage: NetworkImage(
                            Global.getHttpPicUrl(item['avater'])))),
                Positioned(
                    top: 70.0,
                    left: 13.0,
                    child: Text(item['userName'] ?? '',
                        style: TextStyle(color: Color(0xff5b5b5b)))),
                Positioned(
                    left: 74.0,
                    top: 12.0,
                    child: Text('班级:',
                        style: TextStyle(color: Color(0xff5b5b5b)))),
                Positioned(
                  left: 110.0,
                  top: 12.0,
                  child: Text(item['className'] ?? '',
                      style: TextStyle(color: Color(0xff5b5b5b))),
                ),
                Positioned(
                    top: 10.0,
                    right: 10.0,
                    child: Icon(Icons.chevron_right, size: 30)),
                Positioned(
                    top: 42.0,
                    left: 74.0,
                    child: Text('请假类型:',
                        style: TextStyle(
                            color: Color(0xffa9a9a9), fontSize: 13.0))),
                Positioned(
                    top: 42.0,
                    left: 134.0,
                    child: Text(
                      getLeaveTypeValue(item['type'] ?? ''),
                      style:
                          TextStyle(color: Color(0xffa9a9a9), fontSize: 13.0),
                    )),
                Positioned(
                    left: 74,
                    top: 69.0,
                    child: Text('开始时间:',
                        style: TextStyle(
                            color: Color(0xffa9a9a9), fontSize: 13.0))),
                Positioned(
                    top: 71.0,
                    left: 134.0,
                    child: Text(formatTime(item['startTime']),
                        style: TextStyle(
                            color: Color(0xffa9a9a9), fontSize: 13.0))),
                Positioned(
                    top: 96.0,
                    left: 74.0,
                    child: Text('结束时间:',
                        style: TextStyle(
                            color: Color(0xffa9a9a9), fontSize: 13.0))),
                Positioned(
                    top: 98.0,
                    left: 134.0,
                    child: Text(formatTime(item['endTime']),
                        style: TextStyle(
                            color: Color(0xffa9a9a9), fontSize: 13.0)))
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical: 5.0),
                //   child: Stack(
                //     alignment: FractionalOffset(1, 0.9),
                //     children: <Widget>[
                //       Row(children: <Widget>[
                //         CircleAvatar(
                //             // radius: 35.0,
                //             backgroundColor: Color(0xffe3dfeb),
                //             backgroundImage: NetworkImage(
                //                 Global.getHttpPicUrl(item['avater']))),
                //         Padding(
                //             padding: EdgeInsets.only(left: 10.0),
                //             child: Text(item['userName'] ?? '',
                //                 style: TextStyle())),
                //       ]),
                //       // Chip(
                //       //     backgroundColor: Color(0xffff0079),
                //       //     label:
                //       //         Text('未复课', style: TextStyle(color: Colors.white)))
                //     ],
                //   ),
                // ),
                // Padding(
                //   padding: EdgeInsets.symmetric(vertical: 5.0),
                //   child: Column(
                //     children: <Widget>[
                //       Row(children: <Widget>[
                //         Text('班级信息:', style: TextStyle()),
                //         Padding(
                //           padding: EdgeInsets.only(left: 10.0),
                //           child:
                //               Text(item['className'] ?? '', style: TextStyle()),
                //         ),
                //       ]),
                //       Row(children: <Widget>[
                //         Text('开始时间:', style: TextStyle()),
                //         Padding(
                //           padding: EdgeInsets.only(left: 10.0),
                //           child: Text(formatTime(item['startTime']),
                //               style: TextStyle()),
                //         ),
                //       ]),
                //       Row(children: <Widget>[
                //         Text('结束日期:', style: TextStyle()),
                //         Padding(
                //           padding: EdgeInsets.only(left: 10.0),
                //           child: Text(formatTime(item['endTime']),
                //               style: TextStyle()),
                //         ),
                //       ])
                //     ],
                //   ),
                // )
              ],
            ),
          ),
        ),
      ],
    );
  }

  String formatTime(String str) {
    if (str == null) {
      return '';
    }
    return formatDate(DateTime.parse(str), [
      yyyy,
      '-',
      mm,
      '-',
      dd,
      ' ',
    ]);
  }

  String getLeaveTypeValue(String str) {
    if (str == null) {
      return '';
    }
    return Dictionary.getNameByUniqueNameAndCode(
        uniqueName: UniqueNameValues[UNIQUE_NAME.LEAVETYPE], code: str);
  }

  Future _getLeaveList() async {
    // print('status:$status');
    var res = await getLeaveList(
        pagination: pagination,
        createUserId: Global.profile.user.id,
        personType: Global.profile.user.personType,
        // status: '',
        status: status);
    // print('res:$res');
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
