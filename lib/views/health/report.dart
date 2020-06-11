import 'package:date_format/date_format.dart';
import 'package:dio/dio.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
import 'package:health/model/health.dart';
import 'package:health/model/profile.dart';
import 'package:health/service/index.dart';
import 'package:health/widget/index.dart';

class HealthReport extends StatefulWidget {
  final String title = '晨午检上报';

  @override
  _HealthReportState createState() => _HealthReportState();
}

class _HealthReportState extends State<HealthReport> {
  Profile _profile = Global.profile;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List _bindClass = [
    {"name": '高一班', "id": '1'},
    {"name": '高三班', "id": '2'}
  ];
  Health _health = new Health();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(widget.title)),
      body: form(),
    );
  }

  Widget form() {
    return Form(
      autovalidate: true,
      child: ListView(
        children: <Widget>[
          infoTitle('基本信息'),
          TextFormField(
              // expands: true,
              readOnly: true,
              enabled: false,
              initialValue: _profile.user.organName,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text('所属地区:')),
                  prefixIconConstraints: BoxConstraints())),
          TextFormField(
              // autofocus: false,

              readOnly: true,
              enabled: false,
              initialValue: _profile.user.schName,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text('学校名称:')),
                  prefixIconConstraints: BoxConstraints())),
          FLListTile(
            title: Text('所属班级'),
            /*Icon(Icons.navigate_next)*/
            trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(_health.className ?? ''),
                  Icon(Icons.navigate_next)
                ]),
            onTap: showPicker,
          ),
          Divider(height: 1),
          FLListTile(
            title: Text('学生信息'),
            trailing: Icon(Icons.navigate_next),
            onTap: openSearch,
          ),
          Divider(height: 1),
          FLListTile(
            title: Text('登记类型'),
            trailing: ChoiceChipOptions(
              data: Dictionary.healthRegisterType,
              onValueChange: (int _index){
                this.setState(() {
                  _health.type = Dictionary.healthRegisterType[_index];
                });
              },
            ),
            // onTap: openSearch,
          ),
          Divider(height: 1),
          FLListTile(
            title: Text('上报类型'),
            trailing: ChoiceChipOptions(data: Dictionary.reportType),
            // onTap: openSearch,
          ),
          Divider(height: 1),
          FLListTile(
            title: Text('发病日期'),
            trailing:  Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(_health.illDate ?? ''),
                  Icon(Icons.calendar_today)
                ]),
            onTap: () {
              showDatePicker(
                  context: context,
                  initialDate: new DateTime.now(),
                  firstDate:
                      new DateTime.now().subtract(new Duration(days: 30)),
                  lastDate: new DateTime.now().add(new Duration(days: 30))).then((value) => {
                    this.setState(() {
                      this._health.illDate = formatDate(value, [yyyy, '-', mm, '-', dd]);
                    })
                  });
            },
          ),
          Divider(height: 1),
          FLListTile(
            title: Text('离校日期'),
            // trailing: Icon(Icons.navigate_next),
            // onTap: openSearch,
          ),
          infoTitle('症状信息'),
         FLListTile(
            title: Text('学生症状'),
            trailing: Icon(Icons.navigate_next),
            // onTap: ,
          ),
          Divider(height: 1),
          ListTile(
              title: Text('是否就诊'), trailing: RadioOptions(data: ['是', '否'])),
          Divider(height: 1),
          ListTile(title: Text('病例类型')),
          Divider(height: 1),
          ListTile(title: Text('确诊详情')),
          Divider(height: 1),
          ListTile(title: Text('就诊日期')),
          Divider(height: 1),
          TextFormField(
              // expands: true,
              // readOnly: true,
              // enabled: false,
              // autofocus: true,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text('就诊医院:')),
                  prefixIconConstraints: BoxConstraints())),
          Divider(height: 1),
          TextFormField(
              // expands: true,
              // readOnly: true,
              // enabled: false,
              // autofocus: true,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  prefixIcon: Padding(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text('采取措施:')),
                  prefixIconConstraints: BoxConstraints())),
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
            child: RaisedButton(onPressed: () {
              _healthReport();
            }, child: Text('提交')),
          )
        ],
      ),
    );
  }

  Widget infoTitle(String title) {
    return Container(
        color: Color(0xffe4e4e4),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 5.0),
        child: Text(title));
  }
/*选择列表*/ 
  showPicker() {
    List<PickerItem> _picerItem =
        _bindClass.map((e) => PickerItem(text: Text(e['name']))).toList();
    Picker picker = Picker(
      adapter: PickerDataAdapter(data: _picerItem),
      title: Text('选择班级'),
      onConfirm: (picker, selecteds) {
        // print(selecteds);
        this.setState(() {
          _health.className = _bindClass[selecteds[0]]['name'];
          _health.classId = _bindClass[selecteds[0]]['id'];
        });
      },
    );
    picker.show(_scaffoldKey.currentState);
  }

  void openSearch() {
    Navigator.of(context).pushNamed('/searchStudent');
  }

  Future _healthReport() async{
    var res = await healthReport(_health);
    // print('healthReport$res');
  }

  
  

  
}
