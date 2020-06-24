import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:health/model/argument.dart';
import 'package:health/model/global.dart';
import 'package:health/service/index.dart';

class LeaveDetail extends StatelessWidget {
  final Argument arg;
  final String title = '请假详情';
  final String defalutBanner = 'images/banner.png';
  LeaveDetail({this.arg});
  @override
  Widget build(BuildContext context) {
    // print('args:${arg.params}');
    Map form = arg.params as Map;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ListTile(
              title: Text('申请人'),
              trailing: Text(form['userName']),
            ),
            Divider(height: 1),
            ListTile(
              title: Text('班级'),
              trailing: Text(form['className']),
            ),
            Divider(height: 1),
            ListTile(
              title: Text('开始时间:'),
              trailing: Text(formatTime(form['startTime'])),
            ),
            Divider(height: 1),
            ListTile(
              title: Text('结束时间:'),
              trailing: Text(formatTime(form['endTime'])),
            ),
            Divider(height: 1),
            Padding(padding: EdgeInsets.symmetric(horizontal: 16,vertical: 10),child: Text('请假事由:',style: Theme.of(context).textTheme.subtitle1)),
            TextFormField(
              readOnly: true,
              initialValue: form['reason'],
              maxLines: 8,
              autofocus: false,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  // prefixIcon: Padding(
                  //     padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  //     child: Text('请假事由:',
                  //         style: Theme.of(context).textTheme.subtitle1)),
                  // prefixIconConstraints: BoxConstraints()
                ),
            ),
            Divider(height: 1),
            // 轮播
            form['photos'] != null
                ? swiper(form['photos'] as List)
                : Container(),

            Offstage(
              offstage: form['status'] == '1',
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                child: RaisedButton(
                  onPressed: () {
                    _approvalLeave(form);
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: Text('确认'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  String formatTime(String str) {
   if(str==null){return '';}
    return formatDate(
        DateTime.parse(str), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
  }

  /*卡片1-轮播图*/
  Widget swiper(List images) {
    return Stack(alignment: FractionalOffset(1, 0.9), children: <Widget>[
      Container(
        height: 200.0,
        child: Swiper(
          itemCount: images.length,
          itemBuilder: (_, index) {
            // print(images[index]);
            return swiperItem(
              imageUrl: images[index] ?? null,
            );
          },
          autoplay: false,
          pagination: new SwiperPagination(),
        ),
      ),
    ]);
  }

  /*轮播-项*/
  Widget swiperItem({String imageUrl}) {
    return Stack(
      alignment: FractionalOffset(0.1, 0.2),
      children: <Widget>[
        imageUrl != null
            ? Image.network(Global.getHttpPicUrl(imageUrl),
                height: 200, fit: BoxFit.cover)
            : Image.asset(defalutBanner, height: 200, fit: BoxFit.cover),
      ],
    );
  }

  Future _approvalLeave(Map item) async{
    await approvalLeave(id:item['id'] ,status: '1');
  }
}
