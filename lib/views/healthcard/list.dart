import 'package:date_format/date_format.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
import 'package:health/model/heaCard.dart';
import 'package:health/model/pagination.dart';
import 'package:health/service/index.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

class HealthCardList extends StatefulWidget {
  final String title = '学生健康卡';
  @override
  _HealthCardListState createState() => _HealthCardListState();
}

class _HealthCardListState extends State<HealthCardList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AppBarController appBarController = AppBarController();
  final defaultImage = 'images/upload_bg.png';
  ScrollController scrollController = ScrollController();
  List _bindClass = [];
  HealthCard healthCard = new HealthCard();
  Pagination pagination = new Pagination(page: 1, rows: 10);

  bool loading = true;
  List dataList = [];
  @override
  void initState() {
    super.initState();
    _bindClass = Global.profile.user.classIdAndNames ?? [];
    // print('_bindClass:$_bindClass');
    healthCard = HealthCard(
        personType: '1',
        classId: _bindClass[0]['classId'] ?? '',
        className: _bindClass[0]['className'] ?? '');
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
      appBar: SearchAppBar(
        appBarController: appBarController,
        searchHint: '搜索',
        mainAppBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            InkWell(
              child: Icon(Icons.search),
              onTap: () {
                appBarController.stream.add(true);
              },
            )
          ],
        ),
        primary: Theme.of(context).primaryColor,
        onChange: (val) {
          if (val != '') {
            this.setState(() {
              dataList = [];
              pagination.page = 1;
              healthCard.name = val;
            });
            _heaCardList();
          }
        },
      ),
      body: Column(
        children: <Widget>[
          FLListTile(
            title: Text('班级信息:'),
            /*Icon(Icons.navigate_next)*/
            trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(healthCard.className ?? ''),
                  Icon(Icons.navigate_next)
                ]),
            onTap: showPicker,
          ),
          Divider(height: 1),
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
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(dataList[_index]['name'] ?? ''),
                            Text(dataList[_index]['createTime'] != null
                                ? formatTime(dataList[_index]['createTime'])
                                : ''),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Chip(
                          label: Text(statusLabel(dataList[_index]['status']),
                              style: TextStyle(color: Colors.white)),
                          backgroundColor:
                              statusColor(dataList[_index]['status']),
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(Icons.navigate_next),
                  onTap: () {
                    Navigator.pushNamed(context, '/healthCardReport',
                        arguments: Argument(
                            params: HealthCard.fromJson(dataList[_index])));
                  },
                ),
                Offstage(
                  offstage: _index == dataList.length - 1,
                  child: Divider(height: 1),
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
    return formatDate(
        DateTime.parse(str), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
  }

  String statusLabel(String code) {
    return Dictionary.getNameByUniqueNameAndCode(
        uniqueName: UniqueNameValues[UNIQUE_NAME.HEASTATUS], code: code);
  }

  // 64a247 a26b47 4747a2 47a25d 5c47a2
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

  showPicker() {
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
            healthCard.className = _bindClass[selecteds[0]]['className'];
            healthCard.classId = _bindClass[selecteds[0]]['classId'];
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
    var res = await heaCardList(healthCard: healthCard, pagination: pagination);
    // print('_heaCardList:${res['list'][0]}');
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
