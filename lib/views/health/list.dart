import 'package:date_format/date_format.dart';
import 'package:flui/flui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_picker/flutter_picker.dart';

import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/health.dart';
import 'package:health/model/pagination.dart';
import 'package:health/service/index.dart';
import 'package:health/widget/index.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

class HealthList extends StatefulWidget {
  final String title = '晨午检查询';
  @override
  _HealthListState createState() => _HealthListState();
}

class _HealthListState extends State<HealthList> {
  final AppBarController appBarController = AppBarController();
  final ScrollController scrollController = ScrollController();
  final defaultAvatar = 'images/upload_bg.png';
  Health health = new Health(personType: '1');
  Pagination pagination = new Pagination(page: 1, rows: 10);
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CalendarController controller = new CalendarController(
      minYear: 2018,
      minYearMonth: 1,
      maxYear: 2020,
      maxYearMonth: 12,
      showMode: CalendarConstants.MODE_SHOW_MONTH_AND_WEEK);
  List dataList = [];
  List heaList =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.HEASTATUS]);
  List checkResultList =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.CHECKRESULT]);
  String leaveTypeValue = '';
  bool empty = false;
  bool firstLoading = true;
  @override
  void initState() {
    super.initState();
    heaList.removeRange(0, 2);
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // print('滑动到了最底部${scrollController.position.pixels}');
        pagination.page += 1;
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
      key: _scaffoldKey,
      appBar: SearchAppBar(
        appBarController: appBarController,
        primary: Theme.of(context).primaryColor,
        searchHint: '输入姓名',
        onChange: (String value) {
          this.setState(() {
            health.name = value;
            pagination.page = 1;
            dataList = [];
          });
          _healthList();
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
        ),
      ),
      body: Column(children: <Widget>[
        FLListTile(
          title: Text('离校日期:', style: TextStyle(fontSize: 14.0)),
          trailing: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Container(width: 100, child: Text(health.leaveDate ?? '')),
                Icon(Icons.calendar_today),
                Container(width: 100, child: Text(health.leaveDateEnd ?? '')),
                Icon(Icons.calendar_today),
              ]),
          onTap: selectDate,
        ),
        Divider(height: 1),
        FLListTile(
          title: Text('上报时间:', style: TextStyle(fontSize: 14.0)),
          trailing: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Container(
                    width: 100, child: Text(health.reportStartTime ?? '')),
                Icon(Icons.calendar_today),
                Container(width: 100, child: Text(health.reportEndTime ?? '')),
                Icon(Icons.calendar_today)
              ]),
          onTap: showCalendar,
        ),
        Divider(height: 1),
        FLListTile(
          title: Text('核查结果:'),
          trailing: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              ChoiceChipOptions(
                data: checkResultList,
                selectIndex: -1,
                label: 'name',
                onValueChange: (val) {
                  this.setState(() {
                    health.checkResult = checkResultList[val]['code'];
                    pagination.page = 1;
                    dataList = [];
                  });
                  _healthList();
                },
              )
            ],
          ),
        ),
        Divider(height: 1),
        Flexible(child: list(), flex: 1)
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
    print('这是什么');
    print(item);
    return InkWell(
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
    // print('这是什么');
    // print(item);
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Stack(
                  alignment: FractionalOffset(1, 0.6),
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
                    InkWell(
                      child: Chip(
                          // item['illStatus']
                          backgroundColor: statusColor(item['illStatus']),
                          label: Text(
                              Dictionary.getNameByUniqueNameAndCode(
                                  uniqueName:
                                      UniqueNameValues[UNIQUE_NAME.HEASTATUS],
                                  code: (item['illStatus'] == null
                                      ? '待确认'
                                      : item['illStatus'])),
                              style: TextStyle(color: Colors.white))),
                      onTap: () {},
                    )
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
              Container(),
              Wrap(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: InkWell(
                        child: Chip(
                          label:
                              Text('正常', style: TextStyle(color: Colors.white)),
                          backgroundColor: Color(0xff00a7ed),
                        ),
                        onTap: () {
                          updateStatus(id: item['id'], illStatus: '2');
                          dataList = [];
                          pagination.page = 1;
                          _healthList();
                        },
                      )),
                  InkWell(
                    child: Chip(
                      label: Text('异常', style: TextStyle(color: Colors.white)),
                      backgroundColor: Color(0xffda0420),
                    ),
                    onTap: () {
                      showPicker(item['id']);
                    },
                  )
                ],
              )
            ],
          ),
        )
      ],
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
    var res = await healthList(health: health, pagination: pagination);
    this.setState(() {
      dataList = res['list'];

      pagination.totalCount = res['totalCount'];
      pagination.pageSize = res['totalCount'];
    });
  }

  void showResult() {}
  Future _healthList() async {
    var res = await healthList(health: health, pagination: pagination);

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

  // Future _healthDelete(String id) async {
  //   await healthDelete(id);
  //   this.setState(() {
  //     dataList = dataList.where((element) => element['id'] != id).toList();
  //   });
  // }

  void _checkDetail(Map item) {
    // print('item$item');
    Navigator.of(context)
        .pushNamed('/healthDetail', arguments: Argument(params: item));
  }

  showPicker(String id) {
    List<PickerItem> _picerItem =
        heaList.map((e) => PickerItem(text: Text(e['name']))).toList();
    Picker picker = Picker(
      height: 200,
      itemExtent: 30,
      adapter: PickerDataAdapter(data: _picerItem),
      title: Text('选择异常状态'),
      onConfirm: (picker, selecteds) {
        print(heaList[selecteds[0]]['code']);
        print(id);
        updateStatus(id: id, illStatus: heaList[selecteds[0]]['code']);
        dataList = [];
        pagination.page = 1;
        _healthList();
      },
    );
    picker.show(_scaffoldKey.currentState);
  }

  Color statusColor(String status) {
    switch (status) {
      case '1':
        return Color(0xffff0079);
      case '2':
        return Color(0xff64a247);
      case '3':
        return Color(0xffa26b47);
      case '4':
        return Color(0xff4747a2);
      case '5':
        return Color(0xff47a25d);
      case '6':
        return Color(0xff3ab25d);
      case '7':
        return Color(0xff5c47a2);
      default:
        return Colors.grey;
    }
  }
}
