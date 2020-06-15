import 'package:flutter/material.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
import 'package:health/model/profile.dart';


class Person extends StatefulWidget {
  @override
  _PersonState createState() => _PersonState();
}

class _PersonState extends State<Person> {
  Profile _profile = Global.profile;
  @override
  Widget build(BuildContext context) {
    return listview();
  }

  Widget listview() {
    // _profile = profileNotify.value;
    print('222${_profile.user.userName}'); 
    return ListView(
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        infoCard(),
        listTile(title: '手机号码', value: _profile.user.phone),
        Divider(height: 1),
        // Dictionary.getNameByUniqueNameAndCode(code:_profile.user.gender,uniqueName: UniqueNameValues[UNIQUE_NAME.GENDER])
        listTile(title: '性别', value:Dictionary.getNameByUniqueNameAndCode(code:_profile.user.gender,uniqueName: UniqueNameValues[UNIQUE_NAME.GENDER])),
        Divider(height: 1),
        listTile(title: '所属机构', value: _profile.user.organName),
        Divider(height: 1),
        listTile(title: '所在校区', value: _profile.user.schName),
        Divider(height: 1),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: RaisedButton(
            onPressed: () {
              Global.quit();
              Navigator.of(context).pushNamed('/login');
            },
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            child: Text('退出登录'),
          ),
        ),
      ],
    );
  }

/*ae96bc e3dfeb*/
  Widget infoCard() {
    return Card(
      shadowColor: Colors.transparent,
      color: Color(0xffae96bc),
      shape: Border.all(style: BorderStyle.none),
      margin: EdgeInsets.all(0),
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50.0),
          child: Row(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 10.0),
              child: CircleAvatar(
                  radius: 35.0,
                  backgroundColor: Color(0xffe3dfeb),
                  backgroundImage: AssetImage('images/upload_bg.png')),
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /*姓名*/
                  Text(_profile.user.userName,
                      style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  Text(_profile.user.schName,
                      style: TextStyle(color: Colors.white)),
                  Text('角色:${_profile.user.roleNames}',
                      style: TextStyle(color: Colors.white))
                ])
          ])),
    );
  }

  Widget listTile({String title, String value}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(right:5.0),
                child: Text(title,
                    style:
                        TextStyle(fontSize: 18.0, color: Color(0xff888888)))),
            Expanded(
              // flex: 1,
              child: Text(value??'',
                  textAlign: TextAlign.right, style: TextStyle(fontSize: 16.0)),
            )
          ]),
    );
  }
}
