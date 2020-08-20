import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 0.0),
              child: Stack(
                children: <Widget>[
                  Container(
                    height: 80.0,
                    color: Color(0xffffffff),
                  ),
                  Positioned(
                      left: 14.0,
                      top: 13.0,
                      child: CircleAvatar(
                          radius: 27.0,
                          backgroundColor: Color(0xffe3dfeb),
                          backgroundImage: NetworkImage(
                              Global.getHttpPicUrl(form['avater'])))),
                  Positioned(
                      left: 84.0, top: 16.0, child: Text(form['userName'])),
                  Positioned(
                    left: 84.0,
                    top: 46.0,
                    child: Text(form['startTime'],
                        style: TextStyle(
                            fontSize: 13.0, color: Color(0xffa9a9a9))),
                  ),
                  Positioned(
                    right: 34.0,
                    top: 26.0,
                    child: Text(getLeaveTypeValue(form['type']),
                        style: TextStyle(
                            fontSize: 18.0, color: Color(0xff6088db))),
                  ),
                ],
              ),
            ),
            Divider(height: 1),
            Padding(
              padding: EdgeInsets.only(left: 0.0),
              child: Container(
                color: Color(0xffffffff),
                child: ListTile(
                  title: Text('班级'),
                  trailing: Text(form['className'] ?? ''),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0.0),
              child: Container(
                color: Color(0xffffffff),
                child: ListTile(
                  title: Text('开始时间:'),
                  trailing: Text(formatTime(form['startTime'])),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0.0),
              child: Container(
                color: Color(0xffffffff),
                child: ListTile(
                  title: Text('结束时间:'),
                  trailing: Text(formatTime(form['endTime'])),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0.0),
              child: Container(
                color: Color(0xffffffff),
                child: ListTile(
                  title: Text('请假类型:'),
                  trailing: Text(getLeaveTypeValue(form['type'])),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0.0),
              child: Container(
                color: Color(0xffffffff),
                child: ListTile(
                    title: Text('请假事由:',
                        style: Theme.of(context).textTheme.subtitle1)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 0.0),
              child: Container(
                color: Color(0xffffffff),
                child: TextFormField(
                  readOnly: true,
                  initialValue: form['reason'],
                  maxLines: 3,
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
              ),
            ),
            // Divider(height: 1),
            // Padding(
            //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            //     child: Text('请假事由:',
            //         style: Theme.of(context).textTheme.subtitle1)),

            form['photos'] != null
                ? swiper(form['photos'] as List)
                : Container(),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Container(
                  color: Color(0xffffffff),
                  child: Offstage(
                    offstage: form['status'] == '1',
                    child: Container(
                      width: double.infinity,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                      child: RaisedButton(
                        onPressed: () {
                          _approvalLeave(form);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0))),
                        child: Text('确认'),
                      ),
                    ),
                  )),
            ),
            Divider(height: 1),
            // 轮播
          ],
        ),
      ),
    );
  }

  String formatTime(String str) {
    if (str == null) {
      return '';
    }
    return formatDate(
        DateTime.parse(str), [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn]);
  }

  String getLeaveTypeValue(String str) {
    if (str == null) {
      return '';
    }
    return Dictionary.getNameByUniqueNameAndCode(
        uniqueName: UniqueNameValues[UNIQUE_NAME.LEAVETYPE], code: str);
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

  Future _approvalLeave(Map item) async {
    await approvalLeave(id: item['id'], status: '1');
  }
}
