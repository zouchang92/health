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
    print('args:${arg.params}');
    Map form = arg.params as Map;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('申请人'),
              trailing: Text(form['userName']),
            ),
            ListTile(
              title: Text('班级'),
              trailing: Text(form['className']),
            ),
            ListTile(
              title: Text('开始时间:'),
              trailing: Text(form['startTime'] ?? ''),
            ),
            Divider(height: 1),
            ListTile(
              title: Text('结束时间:'),
              trailing: Text(form['endTime'] ?? ''),
            ),
            Divider(height: 1),
            TextFormField(
              readOnly: true,
              initialValue: form['reason'],
              maxLines: 8,
              autofocus: false,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text('请假事由:',
                          style: Theme.of(context).textTheme.subtitle1)),
                  prefixIconConstraints: BoxConstraints()),
            ),
            // 轮播
            form['photos'] != null
                ? swiper(form['photos'] as List)
                : Container(),

            Offstage(
              offstage: form['status'] == 3,
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