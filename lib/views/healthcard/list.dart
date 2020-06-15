import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

class HealthCardList extends StatefulWidget {
  final String title = '学生健康卡';
  @override
  _HealthCardListState createState() => _HealthCardListState();
}

class _HealthCardListState extends State<HealthCardList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final AppBarController appBarController = AppBarController();
  List _bindClass = [
    {"name": '高一班', "id": '1'},
    {"name": '高三班', "id": '2'}
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        appBarController: appBarController,
        searchHint: '搜索',
        mainAppBar: AppBar(
          title:Text(widget.title),
          actions: <Widget>[
            InkWell(
              child: Icon(Icons.search),
              onTap: (){
                appBarController.stream.add(true);
              },
            )
          ],
        ),
        primary: Theme.of(context).primaryColor,
        onChange: (val){

        },
      ),
      body:Column(
        children: <Widget>[
          FLListTile(
            title: Text('班级信息:'),
            /*Icon(Icons.navigate_next)*/
            trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(''),
                  Icon(Icons.navigate_next)
                ]),
            onTap: showPicker,
          ),
          Divider(height:1)
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