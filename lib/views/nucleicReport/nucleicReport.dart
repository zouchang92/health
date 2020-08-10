import 'dart:convert';

import 'package:date_format/date_format.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';

import 'package:health/model/nuclecReport.dart';
import 'package:health/model/pagination.dart';
import 'package:health/service/index.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

class NucleicReportList extends StatefulWidget {
  final String title = '学生核酸信息';
  @override
  _NucleicReportList createState() => _NucleicReportList();
}

class _NucleicReportList extends State<NucleicReportList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AppBarController appBarController = AppBarController();
  final defaultImage = 'images/upload_bg.png';
  ScrollController scrollController = ScrollController();
  List _bindClass = [];
  NuclecReport nuclecReport = new NuclecReport();
  Pagination pagination = new Pagination(page: 1, rows: 10);

  bool loading = true;
  List dataList = [];
  @override
  void initState() {
    super.initState();
    _bindClass = Global.profile.user.classIdAndNames ?? [];
    // print('_bindClass:$_bindClass');
    nuclecReport = NuclecReport(
      personType: '1',
      // classId: _bindClass[0]['classId'] ?? '',
      // className: _bindClass[0]['className'] ?? ''
    );
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // print('滑动到了最底部${scrollController.position.pixels}');

        if (pagination.pageSize == pagination.totalCount) {
          pagination.page += 1;
          // _getLeaveList();
          _heaCardList();
        }
      }
    });
    _heaCardList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: <Widget>[
          FLListTile(
            title: Text('所属班级:'),
            /*Icon(Icons.navigate_next)*/
            trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(nuclecReport.className ?? ''),
                  Icon(Icons.navigate_next)
                ]),
            onTap: showPicker,
          ),
          Divider(height: 1, color: Colors.black),
          Flexible(child: pageList(), flex: 1)
        ],
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
            return Column(
              children: <Widget>[
                ListTile(
                  title: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: dataList[_index]['fileUrl'] != null
                            ? NetworkImage(Global.getHttpPicUrl(
                                dataList[_index]['fileUrl']))
                            : AssetImage(defaultImage),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  dataList[_index]['name'] ?? '',
                                  textAlign: TextAlign.left,
                                ),
                              )
                            ]),
                            Row(children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  '检测时间:',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 0.0),
                                child: Text(
                                  dataList[_index]['createTime'] != null
                                      ? formatTime(
                                          dataList[_index]['createTime'])
                                      : '',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: Text(
                                  '检测次数:',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 0.0),
                                child: Text(
                                  dataList[_index]['totalTimes'].toString(),
                                  style: TextStyle(
                                    fontSize: 15.0,
                                  ),
                                ),
                              )
                            ]),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    var item = dataList[_index];

                    // 这里传的参数是Map类型 监测页面没必要在转为class了 直接用就行了
                    Navigator.pushNamed(context, '/nucleicRecord',
                        arguments:
                            Argument(params: item['heaInfoDailyNATDTOList']));
                  },
                ),
                Offstage(
                  offstage: _index == dataList.length - 1,
                  child: Divider(height: 1),
                ),
                Divider(
                  height: 1,
                )
              ],
            );
          },
          itemCount: dataList.length,
        );
      }
    }
  }

  String formatTime(String str) {
    return formatDate(DateTime.parse(str), [
      yyyy,
      '-',
      mm,
      '-',
      dd,
      ' ',
    ]);
  }

  String statusLabel(String code) {
    return Dictionary.getNameByUniqueNameAndCode(
        uniqueName: UniqueNameValues[UNIQUE_NAME.HEASTATUS], code: code);
  }

  showPicker() {
    print('12314');
    // print(_heaCardList());
    if (_bindClass.length == 0) {
      FLToast.info(text: '未绑定班级!');
    } else {
      List<PickerItem> _picerItem = _bindClass
          .map((e) => PickerItem(text: Text(e['className'] ?? '')))
          .toList();
      Picker picker = Picker(
        height: 0.3 * MediaQuery.of(context).size.height,
        itemExtent: 36,
        adapter: PickerDataAdapter(data: _picerItem),
        title: Text('选择班级'),
        onConfirm: (picker, selecteds) {
          print(_bindClass[selecteds[0]]);
          this.setState(() {
            nuclecReport.className = _bindClass[selecteds[0]]['className'];
            nuclecReport.classId = _bindClass[selecteds[0]]['classId'];
            dataList = [];
            pagination.page = 1;
          });
          _heaCardList();
        },
      );
      picker.show(_scaffoldKey.currentState);
    }
  }

  Future _heaCardList() async {
    var res = await getStuHea(pagination: pagination);
    this.setState(() {
      loading = false;
    });
    if (res != null) {
      if (res.length > 0) {
        this.setState(() {
          dataList.addAll(res['list']);
          pagination.totalCount = res['totalCount'];
          pagination.pageSize = res['totalCount'];
        });
      }
    }
  }
}
