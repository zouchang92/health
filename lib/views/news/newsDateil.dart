import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:health/model/argument.dart';

class NewsDetail extends StatelessWidget {
  final String title = '通知详情';
  final Argument args;
  NewsDetail({this.args});
  @override
  Widget build(BuildContext context) {
    Map news = args.params;
    print('news:$news');
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Wrap(
                children: <Widget>[
                  RichText(
                      text: TextSpan(
                    text: news['title'],
                    style: TextStyle(color: Colors.black, fontSize: 28.0),
                  ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Wrap(
                children: <Widget>[
                 Html(data: news['content']),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.end,
                   children: <Widget>[
                     Text(news['publishTime']!=null?formatTime(news['publishTime']):'')
                   ],
                 )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  String formatTime(String str) {
    return formatDate(
        DateTime.parse(str), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
  }
}
