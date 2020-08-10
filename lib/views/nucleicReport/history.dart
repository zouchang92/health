import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
import 'package:health/model/pagination.dart';
import 'package:health/service/index.dart';

class NucleicHistory extends StatefulWidget {
  final String title = '核酸上报历史';
  @override
  _NucleicHistory createState() => _NucleicHistory();
}

class _NucleicHistory extends State<NucleicHistory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  Pagination pagination = Pagination(page: 1, rows: 10);
  bool loading = true;
  List dataList = [];
  @override
  void initState() {
    super.initState();
    _getStuHea();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // print('滑动到了最底部${scrollController.position.pixels}');
        this.pagination.page += 1;
        if (pagination.pageSize == pagination.totalCount) {
          this.pagination.page += 1;
          _getStuHea();
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
            return _getStuHea();
          }),
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
              margin: EdgeInsets.all(15.0),
              clipBehavior: Clip.antiAlias,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              child: cardContent((dataList[_index] as Map)),
            );
          },
          itemCount: dataList.length,
        );
      }
    }
  }

  Widget cardContent(Map item) {
    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Stack(
          alignment: FractionalOffset(1, 0.9),
          children: <Widget>[
            Row(children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10.0, top: 20.0),
                child: CircleAvatar(
                    // radius: 35.0,
                    // backgroundColor: Color(0xffe3dfeb),
                    backgroundImage: NetworkImage(
                        Global.getHttpPicUrl(Global.profile.user.photo))),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Text(item['name'])),
            ]),
          ],
        ),
      ),
      Padding(
          padding: EdgeInsets.only(left: 60.0, bottom: 20.0),
          child: Column(children: <Widget>[
            Row(children: <Widget>[
              Text('检测结论:'),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(Dictionary.getNameByUniqueNameAndCode(
                    uniqueName: UniqueNameValues[UNIQUE_NAME.CHECKRESULTS],
                    code: (item['checkResult'] == null
                        ? '确诊'
                        : item['checkResult']))),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.0),
                child: Text('检测时间'),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(item['createTime'] != null
                    ? formatTime(item['createTime'])
                    : ''),
              ),
            ]),
          ]))
    ]);
  }

  String formatTime(String str) {
    return formatDate(DateTime.parse(str), [yyyy, '-', mm, '-', dd, ' ']);
  }

  Future _getStuHea() async {
    var res = await getStuHea(
        pagination: pagination, name: Global.profile.user.userName);
    // print('res:$res');
    this.setState(() {
      loading = false;
    });
    if (res != null) {
      if (res['list'].length > 0) {
        this.setState(() {
          dataList.addAll(res['list'][0]['heaInfoDailyNATDTOList']);
          pagination.totalCount = res['totalCount'];
          pagination.pageSize = res['totalCount'];
        });
      }
    }
    print(dataList);
  }
}
