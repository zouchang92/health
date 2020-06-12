import 'package:date_format/date_format.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';

class HealthList extends StatefulWidget {
  String title = '晨午检查询';
  @override
  _HealthListState createState() => _HealthListState();
}

class _HealthListState extends State<HealthList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(children: <Widget>[
        FLListTile(
          title: Text('离校日期'),
          trailing: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[Text(''), Icon(Icons.calendar_today)]),
          onTap: selectDate,
        ),
        Flexible(child: 
         ListView(children: <Widget>[])
        ,flex:1)
      ]),
    );
  }

  void selectDate() async {
    showDatePicker(
            context: context,
            initialDate: new DateTime.now(),
            firstDate: new DateTime.now().subtract(new Duration(days: 30)),
            lastDate: new DateTime.now().add(new Duration(days: 30)))
        .then((value) => {
              this.setState(() {
                // this._health.illDate =
                //     formatDate(value, [yyyy, '-', mm, '-', dd]);
              })
            });
  }
}
