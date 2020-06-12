import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

class HealthCardList extends StatefulWidget {
  final String title = '学生健康卡';
  @override
  _HealthCardListState createState() => _HealthCardListState();
}

class _HealthCardListState extends State<HealthCardList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List _bindClass = [
    {"name": '高一班', "id": '1'},
    {"name": '高三班', "id": '2'}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text(widget.title)),
      body:Column(
        children: <Widget>[
          FLListTile(
            title: Text('所属班级'),
            /*Icon(Icons.navigate_next)*/
            trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(''),
                  Icon(Icons.navigate_next)
                ]),
            onTap: showPicker,
          ),
        ],
      ) ,
    );
  }
  showPicker() {
    List<PickerItem> _picerItem =
        _bindClass.map((e) => PickerItem(text: Text(e['name']))).toList();
    Picker picker = Picker(
      adapter: PickerDataAdapter(data: _picerItem),
      title: Text('选择班级'),
      onConfirm: (picker, selecteds) {
        // print(selecteds);
        // this.setState(() {
        //   _health.className = _bindClass[selecteds[0]]['name'];
        //   _health.classId = _bindClass[selecteds[0]]['id'];
        // });
      },
    );
    picker.show(_scaffoldKey.currentState);
  }
}