import 'package:date_format/date_format.dart';
import 'package:flui/flui.dart';
// import 'package:flui/flui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';

import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
import 'package:health/model/health.dart';
import 'package:health/model/pagination.dart';
import 'package:health/service/index.dart';
import 'package:health/widget/index.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

class HealthInfoReportList extends StatefulWidget {
  final String title = '家长上报';
  @override
  _HealthInfoReportListState createState() => _HealthInfoReportListState();
}

class _HealthInfoReportListState extends State<HealthInfoReportList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AppBarController appBarController = AppBarController();
  final ScrollController scrollController = ScrollController();
  final defaultAvatar = 'images/upload_bg.png';
  Health health = new Health(personType: '1');
  Pagination pagination = new Pagination(page: 1, rows: 10);
  CalendarController controller = new CalendarController(
      minYear: 2018,
      minYearMonth: 1,
      maxYear: 2020,
      maxYearMonth: 12,
      showMode: CalendarConstants.MODE_SHOW_MONTH_AND_WEEK);
  List dataList = [];
  bool empty = false;
  bool firstLoading = true;
  List bindClass = [];
  List symTypeList =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.SYMPTOMTYPE]);
  List reportStatusList =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.REPORTSTATUS]);
  List<String> selecteds = [];
  @override
  void initState() {
    super.initState();
    bindClass = Global.profile.user.classIdAndNames ?? [];
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // print('滑动到了最底部${scrollController.position.pixels}');
        if (pagination.pageSize == pagination.totalCount) {
          pagination.page += 1;
          _healthList();
        }
      }
    });
    _healthList();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // AppBar(title: Text(widget.title))
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      endDrawer: Drawer(
        child: SingleChildScrollView(
          child: drawerContent(),
        ),
      ),
      body: Column(children: <Widget>[
        FLListTile(
          title: Text(
            '上报日期',
            style: TextStyle(fontSize: 14),
          ),
          trailing: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Container(
                    width: 100, child: Text(health.reportStartTime ?? '')),
                Icon(Icons.calendar_today),
                Container(width: 100, child: Text(health.reportEndTime ?? '')),
                Icon(Icons.calendar_today),
              ]),
          onTap: selectDate,
        ),
        Divider(height: 1),
        Flexible(
          child: list(),
          flex: 1,
        )
      ]),
    );
  }

  // Widget _buildTableCalendar() {
  //   return TableCalendar(calendarController: _calendarController);
  // }

  Widget list() {
    if (firstLoading == true) {
      return Center(child: Text('加载中...'));
    }
    if (firstLoading == false) {
      if (dataList.length == 0) {
        return Center(child: Text('--没有数据--'));
      } else {
        return RefreshIndicator(
            child: ListView(
                controller: scrollController,
                children: dataList.map((e) => listItem(e)).toList()),
            onRefresh: _push);
      }
    }
    return Container();
  }

  Widget listItem(Map item) {
    return GestureDetector(
      child: Card(
        // color: Color(0xffae96bc),
        margin: EdgeInsets.all(0.0),
        clipBehavior: Clip.antiAlias,
        // elevation: 5.0,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: cardContent(item),
      ),
      onTap: () {
        _checkDetail(item);
      },
    );
  }

/*
*/
  Widget cardContent(Map item) {
    return Stack(
      children: <Widget>[
        Container(
          height: 80.0,
          color: Color(0xffffffff),
        ),
        Divider(height: 1),
        // Positioned(
        //   top: 14.0,
        //   left: 45.0,
        //   child: CircleAvatar(
        //       radius: 25.0,
        //       backgroundColor: Color(0xffe3dfeb),
        //       backgroundImage: AssetImage(defaultAvatar)),
        // ),
        Positioned(top: 15.0, left: 60.0, child: Text('姓名:')),
        Positioned(
            top: 15.0,
            left: 95.0,
            child: Text(item['name'] ?? '',
                style: TextStyle(color: Colors.black))),
        Positioned(
            top: 45.0,
            left: 60.0,
            child: Text('检测结论:',
                style: TextStyle(fontSize: 14.0, color: Color(0xffa9a9a9)))),
        Positioned(
            top: 45.0,
            left: 125.0,
            child: Text(
                Dictionary.getNameByUniqueNameAndCode(
                    uniqueName: UniqueNameValues[UNIQUE_NAME.REPORTSTATUS],
                    code: item['checkResult']),
                style: TextStyle(fontSize: 14.0, color: Color(0xffa9a9a9)))),
        Positioned(
            top: 45.0,
            right: 90.0,
            child: Text('体温:',
                style: TextStyle(fontSize: 14.0, color: Color(0xff537ed8)))),
        Positioned(
            top: 47.0,
            right: 40.0,
            child: Text(item['temp'].toString() + '℃',
                style: TextStyle(fontSize: 14.0, color: Color(0xff537ed8)))),
        Positioned(
            top: 10.0, right: 10.0, child: Icon(Icons.chevron_right, size: 30)),
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 10.0),
        //   child: Column(
        //     children: <Widget>[
        //       Padding(
        //         padding: EdgeInsets.symmetric(vertical: 5.0),
        //         child: Stack(
        //           alignment: FractionalOffset(1, 0.9),
        //           children: <Widget>[
        //             Row(children: <Widget>[
        //               // CircleAvatar(
        //               //     // radius: 35.0,
        //               //     backgroundColor: Color(0xffe3dfeb),
        //               //     // backgroundImage: AssetImage(defaultAvatar),
        //               //     backgroundImage:
        //               //         (item['photo'] == null && item['photo'] == '')
        //               //             ? AssetImage(defaultAvatar)
        //               //             : NetworkImage(
        //               //                 Global.getHttpPicUrl(item['photo']))),
        //               Text('姓名:', style: TextStyle(color: Colors.black)),
        //               Padding(
        //                 padding: EdgeInsets.only(left: 10.0),
        //                 child: Positioned(
        //                     child: Text(item['name'] ?? '',
        //                         style: TextStyle(color: Colors.black))),
        //               ),
        //               Padding(
        //                 padding: EdgeInsets.only(left: 20.0),
        //                 child: Text('班级信息:',
        //                     style: TextStyle(color: Colors.black)),
        //               ),
        //               Padding(
        //                 padding: EdgeInsets.only(left: 10.0),
        //                 child: Text(item['className'] ?? '',
        //                     style: TextStyle(color: Colors.black)),
        //               ),
        //             ]),
        //             // Chip(
        //             //     backgroundColor: Color(0xffff0079),
        //             //     label:
        //             //         Text('未复课', style: TextStyle(color: Colors.white)))
        //           ],
        //         ),
        //       ),
        //       Padding(
        //         padding: EdgeInsets.symmetric(vertical: 5.0),
        //         child: Column(
        //           children: <Widget>[
        //             // Row(children: <Widget>[
        //             //   Text('班级信息:', style: TextStyle(color: Colors.white)),
        //             //   Padding(
        //             //     padding: EdgeInsets.only(left: 10.0),
        //             //     child: Text(item['className'] ?? '',
        //             //         style: TextStyle(color: Colors.white)),
        //             //   ),
        //             // ]),
        //             Row(children: <Widget>[
        //               Text('记录状态:', style: TextStyle(color: Colors.black)),
        //               Padding(
        //                 padding: EdgeInsets.only(left: 10.0),
        //                 child: Chip(
        //                     backgroundColor: Color(0xffff6000),
        //                     label: Text(
        //                         Dictionary.getNameByUniqueNameAndCode(
        //                             uniqueName: UniqueNameValues[
        //                                 UNIQUE_NAME.REPORTSTATUS],
        //                             code: item['checkResult']),
        //                         style: TextStyle(color: Colors.white))),
        //               ),
        //               SizedBox(width: 100.0),
        //               Text('体温:', style: TextStyle(color: Colors.blue)),
        //               Padding(
        //                 padding: EdgeInsets.only(left: 10.0),
        //                 child: Text(item['temp'].toString(),
        //                     style: TextStyle(color: Colors.blue)),
        //               )
        //             ])
        //           ],
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        Positioned(
            top: 15,
            left: 5,
            child: Checkbox(
                value: selecteds.contains(item['id']),
                onChanged: (val) {
                  this.setState(() {
                    if (val) {
                      if (!selecteds.contains(item['id'])) {
                        selecteds.add(item['id']);
                        showBottom();
                      }
                    } else {
                      if (selecteds.contains(item['id'])) {
                        selecteds.remove(item['id']);
                      }
                    }
                  });
                }))
      ],
    );
  }

  Widget drawerContent() {
    return Container(
      color: Color(0xfff2f2f2),
      height: MediaQuery.of(context).size.height,
      // padding: EdgeInsets.only(top: 25, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SafeArea(
            // padding: EdgeInsets.only(top: 25, left: 20),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('症状信息:'),
                  ChoiceChipOptions(
                    selectIndex: -1,
                    data: symTypeList,
                    label: 'name',
                    onValueChange: (val) {
                      this.setState(() {
                        health.symptomType = symTypeList[val]['code'];
                      });
                    },
                  )
                ],
              ),
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('记录状态:'),
                ChoiceChipOptions(
                  selectIndex: -1,
                  data: reportStatusList,
                  label: 'name',
                  onValueChange: (val) {
                    this.setState(() {
                      health.checkResult = reportStatusList[val]['code'];
                    });
                  },
                )
              ],
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('体温信息/(℃):'),
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    WhitelistingTextInputFormatter(RegExp("[.,0-9]"))
                  ],
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      prefixIcon: Padding(
                          padding: EdgeInsets.only(left: 15.0, right: 10.0),
                          child: Text('大于或等于:')),
                      prefixIconConstraints: BoxConstraints()),
                  onChanged: (val) {
                    health.temp = double.parse(val);
                  },
                ),
              ],
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('班级信息:'),
                ChoiceChipOptions(
                  selectIndex: -1,
                  data: bindClass,
                  label: 'className',
                  onValueChange: (val) {
                    this.setState(() {
                      health.classId = bindClass[val]['classId'];
                    });
                  },
                )
              ],
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
            child: RaisedButton(
              onPressed: () {
                this.setState(() {
                  dataList = [];
                  pagination.page = 1;
                });
                _healthList();
                Navigator.of(context).pop();
              },
              color: Colors.blue,
              highlightColor: Colors.blue[700],
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: Text('确定'),
              ),
            ),
          )
        ],
      ),
    );
  }

  void selectDate() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return MultiSelectStylePage(
            onSubmit: (value) {
              print('onSubmit:$value');
              DateTime st;
              DateTime et;
              if (value.length == 2) {
                st = value[0].isBefore(value[1]) ? value[0] : value[1];
                et = value[0].isAfter(value[1]) ? value[0] : value[1];
              }
              if (value.length == 1) {
                st = value[0];
                et = value[0];
              }
              this.setState(() {
                // formatDate(value, [yyyy, '-', mm, '-', dd]);
                health.reportStartTime =
                    formatDate(st, [yyyy, '-', mm, '-', dd]);
                health.reportEndTime = formatDate(et, [yyyy, '-', mm, '-', dd]);
                dataList = [];
              });
              _healthList();
              Navigator.of(context).pop();
            },
            onCancle: () {
              // print('cancle');
              Navigator.of(context).pop();
            },
          );
        });
  }

  void showCalendar() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return MultiSelectStylePage(
            onSubmit: (value) {
              print('onSubmit:$value');
              DateTime st;
              DateTime et;
              if (value.length == 2) {
                st = value[0].isBefore(value[1]) ? value[0] : value[1];
                et = value[0].isAfter(value[1]) ? value[0] : value[1];
              }
              if (value.length == 1) {
                st = value[0];
                et = value[0];
              }
              this.setState(() {
                // formatDate(value, [yyyy, '-', mm, '-', dd]);
                health.reportStartTime =
                    formatDate(st, [yyyy, '-', mm, '-', dd]);
                health.reportEndTime = formatDate(et, [yyyy, '-', mm, '-', dd]);
                dataList = [];
              });
              _healthList();
              Navigator.of(context).pop();
            },
            onCancle: () {
              print('cancle');
              Navigator.of(context).pop();
            },
          );
        });
  }

  Future _push() async {
    this.setState(() {
      pagination.page = 1;
    });
    var res =
        await getHealthInfoReportList(health: health, pagination: pagination);
    this.setState(() {
      dataList = res['list'];

      pagination.totalCount = res['totalCount'];
      pagination.pageSize = res['totalCount'];
    });
  }

  Future _healthList() async {
    var res =
        await getHealthInfoReportList(health: health, pagination: pagination);

    print(res);
    this.setState(() {
      this.firstLoading = false;
      // studentList = res['list'];
      if (res != null) {
        dataList.addAll(res['list']);
        pagination.totalCount = res['totalCount'];
        pagination.pageSize = res['totalCount'];
      } else {
        this.empty = true;
      }
      health.temp = null;
      health.symptomType = '';
      health.classId = '';
      health.checkResult = '';
      // print('studentList:$studentList');
    });
  }

  void _checkDetail(Map item) {
    // print('item$item');
    Navigator.of(context)
        .pushNamed('/HealthReportDetail', arguments: Argument(params: item));
  }

  void showBottom() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Wrap(children: <Widget>[
                  Text('已选'),
                  Text(
                      '${selecteds.length.toString()}/${pagination.totalCount.toString()}')
                ]),
                RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    onPressed: () {
                      updateAllStatus(checkResult: '1', id: selecteds);
                    },
                    child: Text('批量正常'))
              ],
            ),
          );
        });
  }
}
