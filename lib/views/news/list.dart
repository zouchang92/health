import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:health/model/argument.dart';
import 'package:health/model/global.dart';
import 'package:health/model/news.dart';
import 'package:health/model/pagination.dart';
import 'package:health/service/index.dart';

class NewsList extends StatefulWidget {
  final String title = '通知列表';
  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  final String defalutBanner = 'images/banner.png';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController scrollController = ScrollController();
  Pagination pagination = Pagination(page: 1, rows: 10);
  News _new = News();
  bool loading = true;
  List dataList = [];
  @override
  void initState() {
    super.initState();
    _getNewsList();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        // print('滑动到了最底部${scrollController.position.pixels}');

        if (pagination.pageSize == pagination.totalCount) {
          pagination.page += 1;

          _getNewsList();
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
            return _getNewsList();
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
              color: Color(0xffae96bc),
              margin: EdgeInsets.all(15.0),
              clipBehavior: Clip.antiAlias,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              child: cardContent(dataList[_index] as Map),
            );
          },
          itemCount: dataList.length,
        );
      }
    }
  }

  Widget cardContent(Map item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('发布者:${item['createUserName'] ?? ''}',
                  style: TextStyle(color: Colors.white)),
              Text(
                  item['publishTime'] != null
                      ? formatTime(item['publishTime'])
                      : '',
                  style: TextStyle(color: Colors.white))
            ],
          ),
        ),
        InkWell(
          child: (item['cover'] != '' && item['cover'] != null)
              ? Image.network(Global.getHttpPicUrl(item['cover']),
                  height: 150.0, width: double.infinity, fit: BoxFit.cover)
              : Image.asset(defalutBanner,
                  height: 150.0, fit: BoxFit.cover, width: double.infinity),
          onTap: () {
            Navigator.of(context)
                .pushNamed('/newsDetail', arguments: Argument(params: item));
          },
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          child: Wrap(
            //  alignment: WrapAlignment.start,
            //  crossAxisAlignment: WrapCrossAlignment.start,
            children: <Widget>[
              Text(item['title'], style: TextStyle(color: Colors.white))
            ],
          ),
        ),
      ],
    );
  }

  String formatTime(String str) {
    return formatDate(
        DateTime.parse(str), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
  }

  Future _getNewsList() async {
    var res = await getNewsList(news: _new, pagination: pagination);
    print('res:$res');
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
