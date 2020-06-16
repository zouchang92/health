import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:health/model/argument.dart';
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
  final defaultImage = '/images/banner.png';
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
    print('_bindClass:$_bindClass');
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // print('滑动到了最底部${scrollController.position.pixels}');
        this.pagination.page += 1;
        if (pagination.pageSize == pagination.totalCount) {
          this.pagination.page += 1;
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
                children: <Widget>[Text(''), Icon(Icons.navigate_next)]),
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
            return ListTile(
              title: Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: 
                    dataList[_index]['fileUrl']!=null?
                    NetworkImage(Global.getHttpPicUrl(dataList[_index]['fileUrl'])):AssetImage(defaultImage),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left:10),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(dataList[_index]['name']??''),
                            Text(dataList[_index]['createTime']??''),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              trailing: Icon(Icons.navigate_next),
              onTap: (){
                Navigator.pushNamed(context, '/healthCardDetail',arguments: Argument(params:HealthCard.fromJson(dataList[_index])));
              },
            );
          },
          itemCount: dataList.length,
        );
      }
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
        adapter: PickerDataAdapter(data: _picerItem),
        title: Text('选择班级'),
        onConfirm: (picker, selecteds) {
          // print(selecteds);
          // this.setState(() {
          //   _health.className = _bindClass[selecteds[0]]['name'];
          //   _health.classId = _bindClass[selecteds[0]]['id'];
          // });
        },
      );
      picker.show(_scaffoldKey.currentState);
    }
  }

  Future _heaCardList() async {
    var res = await heaCardList(healthCard: healthCard, pagination: pagination);
    print('_heaCardList:$res');
    this.setState(() {
      loading = false;
    });
    if (res != null) {
      if (res.length > 0) {
        this.setState(() {
          dataList = res['list'];
          pagination.totalCount = res['totalCount'];
          pagination.pageSize = res['totalCount'];
        });
      }
    }
  }
}
