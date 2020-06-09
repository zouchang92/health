import 'package:flutter/material.dart';

class Person extends StatefulWidget {
  @override
  _PersonState createState() => _PersonState();
}

class _PersonState extends State<Person> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(0),
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        infoCard(),
        listTile(title: '手机号码', value: '15579297489'),
        Divider(height: 1),
        listTile(title: '性别', value: '男'),
        Divider(height: 1),
        listTile(title: '所属机构', value: ''),
        Divider(height: 1),
        listTile(title: '所在校区', value: ''),
        Divider(height: 1),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 50),
          child: RaisedButton(
            onPressed: () {
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
                  Text('例如风',
                      style: TextStyle(color: Colors.white, fontSize: 20.0)),
                  Text('九江一中', style: TextStyle(color: Colors.white)),
                  Text('工号:15475644', style: TextStyle(color: Colors.white))
                ])
          ])),
    );
  }

  Widget listTile({String title, String value}) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Text(title,
                style: TextStyle(fontSize: 18.0, color: Color(0xff888888))),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(value, style: TextStyle(fontSize: 16.0)),
          )
        ]);
  }
}
