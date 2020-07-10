import 'package:date_format/date_format.dart';
import 'package:flui/flui.dart';
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
  final String title = '健康上报查询';
  @override
  _HealthInfoReportListState createState() => _HealthInfoReportListState();
}

class _HealthInfoReportListState extends State<HealthInfoReportList> {
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
  @override
  void initState() {
    super.initState();
    bindClass = Global.profile.user.classIdAndNames ?? [];
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // print('滑动到了最底部${scrollController.position.pixels}');
        if (pagination.pageSize == pagination.totalCount) {
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      endDrawer: Drawer(
        child: SingleChildScrollView(
          child: drawerContent(),
        ),
      ),
      body: Column(children: <Widget>[Flexible(child: list(), flex: 1)]),
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
        color: Color(0xffae96bc),
        margin: EdgeInsets.all(15.0),
        clipBehavior: Clip.antiAlias,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0))),
        child: cardContent(item),
      ),
      onTap: () {
        _checkDetail(item);
      },
    );
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
                      // CircleAvatar(
                      //     // radius: 35.0,
                      //     backgroundColor: Color(0xffe3dfeb),
                      //     backgroundImage: AssetImage(defaultAvatar),
                      //     // backgroundImage: (item['photo']==null&&item['photo']=='')?AssetImage(defaultAvatar):NetworkImage(Global.getHttpPicUrl(item['photo']))
                      //   ),
                      Text('姓名:', style: TextStyle(color: Colors.white)),
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
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: <Widget>[
                      Text('确诊时间:', style: TextStyle(color: Colors.white)),
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

  Widget drawerContent() {
    return Container(
      color: Color(0xfff2f2f2),
      height: MediaQuery.of(context).size.height,
      // padding: EdgeInsets.only(top: 25, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 25, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('症状信息:'),
                ChoiceChipOptions(
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
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('记录状态:'),
                ChoiceChipOptions(
                  data: reportStatusList,
                  label: 'name',
                  onValueChange: (val) {},
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
                  data: bindClass,
                  label: 'className',
                )
              ],
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
                health.leaveDate = formatDate(st, [yyyy, '-', mm, '-', dd]);
                health.leaveDateEnd = formatDate(et, [yyyy, '-', mm, '-', dd]);
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
      // print('studentList:$studentList');
    });
  }

  void _checkDetail(Map item) {
    // print('item$item');
    Navigator.of(context)
        .pushNamed('/healthDetail', arguments: Argument(params: item));
  }
}
