import 'package:flutter/material.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
import 'package:health/model/heaCard.dart';
import 'package:health/model/user.dart';
import 'package:health/service/index.dart';
import 'package:health/widget/index.dart';

class HealthCardReport extends StatefulWidget {
  final String title = '学生健康卡';
  @override
  _HealthCardReportState createState() => _HealthCardReportState();
}

class _HealthCardReportState extends State<HealthCardReport> {
  final _formKey = GlobalKey<FormState>();
  final User user = Global.profile.user;
  HealthCard healthCard = new HealthCard();
  List yn = Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.BOOLEAN]);
  @override
  void initState() {
    super.initState();
    healthCard = HealthCard(
      isDiscomfort: yn[0]['code'],
      isSuspected: yn[0]['code'],
      isPyrexia: yn[0]['code'],
      isQuarantine: yn[0]['code'],
      name: user.userName,
      idCard: user.id,
      phone: user.phone,
      personType: user.personType
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          cardInfo(),
          form(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: RaisedButton(
              onPressed: () {
                _submit();
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0))),
              child: Text('提交'),
            ),
          ),
        ]),
      ),
    );
  }

  Widget cardInfo() {
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
                      backgroundImage: user.photo != null
                          ? NetworkImage(Global.getHttpPicUrl(user.photo))
                          : AssetImage('images/upload_bg.png')),
                  Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(user.userName ?? '',
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
                          child: Text(user.credNum ?? '',
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
                          child: Text(user.phone ?? '',
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
                          child: Text(user.credNum ?? '',
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
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            ListTile(
                title: Text('是否发热:'),
                trailing: RadioOptions(
                    data: yn, label: 'name', onValueChange: (int _index) {
                      this.setState(() { 
                         healthCard.isPyrexia = yn[_index]['code'];
                      });
                    })),
            Divider(height: 1),
            ListTile(
                title: Text('是否接触疑似人员:'),
                trailing: RadioOptions(
                    data: yn, label: 'name', onValueChange: (_index) {
                      this.setState(() { 
                        healthCard.isSuspected = yn[_index]['code'];
                      });
                    })),
            Divider(height: 1),
            ListTile(
                title: Text('是否有不适应症状:'),
                trailing: RadioOptions(
                    data: yn, label: 'name', onValueChange: (_index) {
                      this.setState(() { 
                        healthCard.isDiscomfort = yn[_index]['code'];
                      });
                    })),
            Divider(height: 1),
            ListTile(
                title: Text('是否有居家或集中隔离:'),
                trailing: RadioOptions(
                    data: yn, label: 'name', onValueChange: (_index) {
                      this.setState(() {
                        healthCard.isQuarantine = yn[_index]['code'];
                       });
                    }))
          ],
        ));
  }

  Future _submit() async{
    print(healthCard.toJson());
    await heaCardAdd(healthCard);
  }
}
