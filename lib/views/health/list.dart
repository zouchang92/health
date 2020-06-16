import 'package:date_format/date_format.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/health.dart';
import 'package:health/model/pagination.dart';
import 'package:health/service/index.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

class HealthList extends StatefulWidget {
  final String title = '晨午检查询';
  @override
  _HealthListState createState() => _HealthListState();
}

class _HealthListState extends State<HealthList> {
  final AppBarController appBarController = AppBarController();
  ScrollController scrollController = ScrollController();
  Health health = new Health(personType: '1');
  Pagination pagination = new Pagination(page: 1, rows: 10);
  List dataList = [];
  bool empty = false;
  bool firstLoading = true;
  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // print('滑动到了最底部${scrollController.position.pixels}');
        if(pagination.pageSize == pagination.totalCount){
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
      appBar: SearchAppBar(
        appBarController: appBarController,
        primary: Theme.of(context).primaryColor,
        searchHint: '输入姓名',
        onChange: (String value) {
          // print(value);
          this.setState(() {
            health.name = value;
            pagination.page = 1;
            _healthList();
          });
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
          title: Text('离校日期'),
          trailing: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(health.leaveDate ?? ''),
                Icon(Icons.calendar_today)
              ]),
          onTap: selectDate,
        ),
        Divider(height: 1),
        Flexible(child: list(), flex: 1)
      ]),
    );
  }

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

  void selectDate() async {
    showDatePicker(
            context: context,
            initialDate: new DateTime.now(),
            firstDate: new DateTime.now().subtract(new Duration(days: 30)),
            lastDate: new DateTime.now().add(new Duration(days: 30)))
        .then((value) => {
              this.setState(() {
                if (value != null) {
                  health.leaveDate =
                      formatDate(value, [yyyy, '-', mm, '-', dd]);
                }
              })
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

  Future _healthList() async {
    var res = await healthList(health: health, pagination: pagination);
    // List t = res['list'];
    // t = t.where((element) => element!=null).toList();
    // Map tt = t[0] as Map;
    // tt.forEach((key, value) {
    //   if(value!=null){
    //     print('key:$key');
    //     print('value:$value');
    //   }
    // });
    // print('res$res');
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
}
