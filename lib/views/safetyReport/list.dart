import 'package:flutter/material.dart';

class SafetyList extends StatefulWidget {
  final String title = '平安上报历史';
  @override
  _SafetyListState createState() => _SafetyListState();
}

class _SafetyListState extends State<SafetyList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text(widget.title)),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CalendarDatePicker(initialDate: DateTime.now(),
             firstDate: DateTime.now().subtract(Duration(days: 30)),
             lastDate: DateTime.now().add(Duration(days: 30)),
             onDateChanged: (dateTime){

            })
          ],
        ),
      ),
    );
  }
}