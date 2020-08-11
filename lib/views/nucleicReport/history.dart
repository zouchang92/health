import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:health/model/argument.dart';
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
              clipBehavior: Clip.antiAlias,
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
          children: <Widget>[
            Container(height: 100),
            Positioned(
                top: 20.0,
                left: 10.0,
                child: CircleAvatar(
                    radius: 30.0,
                    backgroundImage: NetworkImage(
                        Global.getHttpPicUrl(Global.profile.user.photo) ??
                            ''))),
            Positioned(top: 22, left: 90, child: Text(item['name'])),
            Positioned(
                top: 30.0,
                right: 10.0,
                child: InkWell(
                  child: Icon(
                    Icons.navigate_next,
                    size: 30.0,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/nucleicHistoryDetail',
                        arguments: Argument(params: item));
                  },
                )),
            Positioned(
              top: 62,
              left: 90,
              child: Text('检测结论:', style: TextStyle(color: Color(0xffa9a9a9))),
            ),
            Positioned(
              top: 62,
              left: 155,
              child: Text(
                  Dictionary.getNameByUniqueNameAndCode(
                      uniqueName: UniqueNameValues[UNIQUE_NAME.CHECKRESULTS],
                      code: (item['checkResult'] == null
                          ? '确诊'
                          : item['checkResult'])),
                  style: TextStyle(color: Color(0xffa9a9a9))),
            ),
            Positioned(
              top: 62,
              left: 210,
              child: Text('检测时间:', style: TextStyle(color: Color(0xffa9a9a9))),
            ),
            Positioned(
              top: 64,
              left: 276,
              child: Text(
                  item['createTime'] != null
                      ? formatTime(item['createTime'])
                      : '',
                  style: TextStyle(color: Color(0xffa9a9a9))),
            ),
          ],
        ),
      ),
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
