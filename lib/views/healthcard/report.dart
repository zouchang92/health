import 'package:flutter/material.dart';
import 'package:health/widget/index.dart';

class HealthCardReport extends StatefulWidget {
  final String title = '学生健康卡';
  @override
  _HealthCardReportState createState() => _HealthCardReportState();
}

class _HealthCardReportState extends State<HealthCardReport> {
  final _formKey = GlobalKey<FormState>();
  List yn = ['是','否'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        child: Column(children: <Widget>[cardInfo()]),
      ),
    );
  }

  Widget cardInfo() {
    return Card(
      color: Color(0xffae96bc),
      margin: EdgeInsets.all(0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: FractionalOffset(0.9, 0.2),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                        backgroundColor: Color(0xffe3dfeb),
                        backgroundImage: AssetImage('images/upload_bg.png')),
                    Padding(
                        padding: EdgeInsets.only(left: 10), child:Column(
                          children: <Widget>[
                            Text('例如大'),
                            Text('高三1班')
                          ],
                        ))
                  ],
                ),
              ),
              Chip(label: Text('待确认'))

            ]
          )
        ],
      ),
    );
  }

  Widget form(){
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('是否发热:'),
            trailing: RadioOptions(data: yn,onValueChange: (int _index){
              
            })
          ),
           ListTile(
            title: Text('是否接触疑似人员:'),
            trailing: RadioOptions(data: yn,onValueChange: (int _index){
              
            })
          ),
           ListTile(
            title: Text('是否有不适应症状:'),
            trailing: RadioOptions(data: yn,onValueChange: (int _index){
              
            })
          ),
           ListTile(
            title: Text('是否有居家或集中隔离:'),
            trailing: RadioOptions(data: yn,onValueChange: (int _index){
              
            })
          )
        ],
      )
    );
  }
}
