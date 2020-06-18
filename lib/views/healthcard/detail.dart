import 'package:flutter/material.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
import 'package:health/model/heaCard.dart';
import 'package:health/model/pagination.dart';
import 'package:health/service/index.dart';

class HealthCardDetail extends StatefulWidget {
  final String title = '学生健康卡2';
  @override
  _HealthCardDetailState createState() => _HealthCardDetailState();
}

class _HealthCardDetailState extends State<HealthCardDetail> {
  final _formKey = GlobalKey<FormState>();
  HealthCard healthCard = new HealthCard();
  @override
  void initState() {
    super.initState();
    getHeaCard();
  }

  @override
  Widget build(BuildContext context) {
    // healthCard
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[cardInfo(), form()],
        ),
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
                      backgroundImage: (healthCard.faceUrl != null&&healthCard.faceUrl!='')
                          ? NetworkImage(
                              Global.getHttpPicUrl(healthCard.faceUrl))
                          : AssetImage('images/upload_bg.png')),
                  Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(healthCard.name ?? '',
                              style: TextStyle(color: Colors.white)),
                          Text(healthCard.className??'', style: TextStyle(color: Colors.white))
                        ],
                      ))
                ],
              ),
            ),
            Chip(
              label: Text(
                statusLabel(healthCard.status),
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: statusColor(healthCard.status),
              
            )
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

  String ynLabel(String code) {
    return Dictionary.getNameByUniqueNameAndCode(
        uniqueName: UniqueNameValues[UNIQUE_NAME.BOOLEAN], code: code);
  }

  String statusLabel(String code){
    return Dictionary.getNameByUniqueNameAndCode(uniqueName: UniqueNameValues[UNIQUE_NAME.HEASTATUS],code: code);
  } 
  // 64a247 a26b47 4747a2 47a25d 5c47a2
  Color statusColor(String status){
    switch (status) {
      
      case '1':
        return Color(0xffff0079);
      case '2':
        return Color(0xff64a247);
      case '3':
        return Color(0xffa26b47);
      case '4':
        return Color(0xff4747a2);
      case '5':return Color(0xff47a25d);
      case '6':return Color(0xff3ab25d);
      case '7':return Color(0xff5c47a2);
      default:return Colors.grey;
    }
  }

  getHeaCard() async {
    String pt = (Global.profile.user.personType == 'studentDuty') ? '1' : '0';
    var res = await heaCardList(
        pagination: Pagination(page: 1, rows: 1),
        healthCard:
            HealthCard(stuNum: Global.profile.user.loginName, personType: pt));
    print('heaCard:${res['list'][0]['status']}');
    if (res != null && res['list'].length > 0) {
      this.setState(() {
        healthCard = HealthCard.fromJson(res['list'][0]);
      });
    }
  }
}
