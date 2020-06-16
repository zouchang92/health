import 'package:flutter/material.dart';
import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
import 'package:health/model/heaCard.dart';

class HealthCardDetail extends StatelessWidget {
  final String title = '详情';
  final Argument argument;
  HealthCardDetail({this.argument});
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    // healthCard
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            cardInfo(),
            form()
          ],
        ),
      ),
    );
  }
  Widget cardInfo() {
    HealthCard healthCard = argument.params;
    return Card(
      color: Color(0xffa196bc),
      shape: Border.all(style: BorderStyle.none),
      margin: EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          Stack(alignment: FractionalOffset(0.9, 0.4), children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                      backgroundColor: Color(0xffe3dfeb),
                      backgroundImage: healthCard.faceUrl != null
                          ? NetworkImage(Global.getHttpPicUrl(healthCard.faceUrl))
                          : AssetImage('images/upload_bg.png')),
                  Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(healthCard.name ?? '',
                              style: TextStyle(color: Colors.white)),
                          Text('', style: TextStyle(color: Colors.white))
                        ],
                      ))
                ],
              ),
            ),
            // Chip(
            //   label: Text(
            //     '待确认',
            //     style: TextStyle(color: Colors.white),
            //   ),
            //   backgroundColor: Color(0xffff0079),
            // )
          ]),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.start,
                    children: <Widget>[
                      Text('学号:', style: TextStyle(color: Colors.white)),
                      Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(healthCard.stuNum ?? '',
                              style: TextStyle(color: Colors.white)))
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.start,
                    children: <Widget>[
                      Text('电话:', style: TextStyle(color: Colors.white)),
                      Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(healthCard.phone ?? '',
                              style: TextStyle(color: Colors.white)))
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    alignment: WrapAlignment.start,
                    children: <Widget>[
                      Text('身份证号:', style: TextStyle(color: Colors.white)),
                      Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(healthCard.idCard ?? '',
                              style: TextStyle(color: Colors.white)))
                    ],
                  ),
                ),
                Row(
                  // crossAxisAlignment: WrapCrossAlignment.center,
                  // alignment: WrapAlignment.start,
                  children: <Widget>[
                    Text('家庭住址:', style: TextStyle(color: Colors.white)),
                    Expanded(
                      flex: 1,
                      child: Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text('',
                              overflow: TextOverflow.clip,
                              style: TextStyle(color: Colors.white))),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget form() {
    HealthCard healthCard = argument.params;
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            ListTile(
                title: Text('是否发热:'),
                trailing: Chip(label: Text(ynLabel(healthCard.isPyrexia))),
                ),
            Divider(height: 1),
            ListTile(
                title: Text('是否接触疑似人员:'),
                trailing: Chip(label: Text(ynLabel(healthCard.isSuspected))),
              ),
            Divider(height: 1),
            ListTile(
                title: Text('是否有不适应症状:'),
                trailing: Chip(label: Text(ynLabel(healthCard.isDiscomfort)))),
            Divider(height: 1),
            ListTile(
                title: Text('是否有居家或集中隔离:'),
                trailing: Chip(label: Text(ynLabel(healthCard.isQuarantine))))
          ],
        ));
  }
  String ynLabel(String code){
    return Dictionary.getNameByUniqueNameAndCode(uniqueName:UniqueNameValues[UNIQUE_NAME.BOOLEAN],code:code);
  }
}