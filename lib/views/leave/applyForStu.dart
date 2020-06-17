import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:health/model/argument.dart';

import 'package:health/model/health.dart';
import 'package:health/model/leaveForm.dart';
import 'package:health/service/index.dart';
import 'package:health/store/profileNotify.dart';
import 'package:health/widget/imagePicker/imagePicker.dart';
import 'package:provider/provider.dart';

class LeaveApplyForStudent extends StatefulWidget {
  final String title = '学生请假申请-代请';
  final Argument args;
  LeaveApplyForStudent({this.args});
  @override
  _LeaveApplyForStudentState createState() => _LeaveApplyForStudentState();
}

class _LeaveApplyForStudentState extends State<LeaveApplyForStudent> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = new GlobalKey();
  LeaveForm leaveForm = new LeaveForm();
  Health _health = new Health();
  // Global.profile.user.classIdAndNames??
  List _bindClass = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title:Text(widget.title),
        
      ),
      body: SingleChildScrollView(
        child: form(),
      ),
    );
  }
  Widget form() {
    final _arg = Provider.of<ProfileNotify>(context).argValue;
    // print('arg:$_arg');
    if (_arg != null) {
      Health _thealth = _arg.params as Health;
      // print('_thealth:${_thealth.toJson()}');
      this.setState(() {
        // _health = Object;
        _health = Health.fromJson(amap(_health.toJson(), _thealth.toJson()));
        // print('_health:${_health.toJson()}');
        // leaveForm.userId = Global.profile.user.id;
      // leaveForm.orgId = Global.profile.user.organId;
      // leaveForm.userName = Global.profile.user.userName;
      // leaveForm.userNum = Global.profile.user.loginName;
        leaveForm.userNum = _health.stuNum;
        leaveForm.orgId = _health.classId;
        // leaveForm.userId = _health
      });
    }
    return Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('班级选择'),
              trailing: Text(_health.className??''),
              onTap: showClassPicker,
            ),
            Divider(height: 1),
            ListTile(
              title: Text('学生选择'),
              trailing:  Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Text(_health.stuNumValue ?? ''),
                  Icon(Icons.navigate_next)
                ]),
              onTap: openSearch,

            ),
            Divider(height: 1),
            ListTile(
              title: Text('开始时间:'),
              trailing: Text(leaveForm.startTime ?? ''),
              onTap: () {
                showPicker('开始时间', onConfirm: (_, selects) {
                  // print('selects:$selects');
                  this.setState(() {
                    leaveForm.startTime = pickerValueFormat(selects);
                  });
                });
              },
            ),
            Divider(height: 1),
            ListTile(
              title: Text('结束时间:'),
              trailing: Text(leaveForm.endTime ?? ''),
              onTap: () {
                //  minValue:leaveForm.startTime!=null?DateTime.parse(leaveForm.startTime):null
                showPicker('结束时间',minValue:leaveForm.startTime!=null?DateTime.parse(leaveForm.startTime):null, onConfirm: (Picker picker, selecteds) {
                  print('结束时间:$selecteds');
                  // print('picker:${picker.g}');

                  this.setState(() {
                    if (leaveForm.startTime != null) {
                      int yq = DateTime.parse(leaveForm.startTime).year;
                      leaveForm.endTime = pickerValueFormat(selecteds,start: yq);
                    } else {
                      leaveForm.endTime = pickerValueFormat(selecteds);
                    }
                  });
                });
              },
            ),
            Container(
              height: 10,
              color: Color(0xffe4e4e4),
            ),
            TextFormField(
                maxLines: 8,
                autofocus: false,
                decoration: InputDecoration(
                    hintText: '输入理由',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text('请假事由:',
                            style: Theme.of(context).textTheme.subtitle1)),
                    prefixIconConstraints: BoxConstraints()),
                onSaved: (val) {
                  leaveForm.reason = val;
                }),
            Container(
              height: 10,
              color: Color(0xffe4e4e4),
            ),
            ImagePickerWidget(
              maxNum: 6,
              onValueChange: (List<File> files) {
                // print('file:${file.path}');
                this.setState(() {
                  // leaveForm.file = [file];
                  if (files.length > 0) {
                    leaveForm.filePaths = files.map((e) => e.path).toList();
                  }
                });
              },
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
              child: RaisedButton(
                onPressed: () {
                  _applicationLeave();
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Text('提交'),
                ),
              ),
            )
          ],
        ));
  }
  Map amap(Map a, Map b) {
    a.forEach((key, _) {
      if(b[key]!=null){
        a[key] = b[key];
      }
     
    });
    // print('a$a');
    return a;
  }

  String pickerValueFormat(List<int> values, {int start}) {
    String one = values[0].toString();
    final String startYear = '19';
    int year;
    if (start == null) {
      if (one.length <= 2) {
        year = int.parse(startYear + one);
      } else {
        int yq = int.parse(one[0]) + int.parse(startYear);
        int yh = int.parse(one.substring(1));

        year = int.parse(yq.toString() + yh.toString());
      }
    } else {
      year = start + values[0];
    }

    int month = values[1] + 1;
    int day = values[2] + 1;
    int hour = values[3];
    int minute = values[4];
    DateTime dt = DateTime(year, month, day, hour, minute);
    return formatDate(dt, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
  }

  Future _applicationLeave() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      
      leaveForm.status = '3';
      // print('leaveForm:${leaveForm.toJson()}');
      leaveApply(leaveForm);
    }
  }

  showPicker(String title, {Function onConfirm, DateTime minValue}) {
    // print('dd');
    Picker picker = Picker(
      height: 200.0,
      itemExtent: 40.0,
      adapter: DateTimePickerAdapter(
          minValue: minValue,
          twoDigitYear: false,
          type: PickerDateTimeType.kYMDHM,
          isNumberMonth: true,
          value: DateTime.now()),
      title: Text(title ?? ''),
      onConfirm: (picker, selecteds) {
        // print('picker:${picker.getSelectedValues()}');
        onConfirm(picker, selecteds);
      },
    );
    picker.show(_scaffoldKey.currentState);
  }

   showClassPicker() {
    List<PickerItem> _picerItem =
        _bindClass.map((e) => PickerItem(text: Text(e['className']))).toList();
    Picker picker = Picker(
      adapter: PickerDataAdapter(data: _picerItem),
      title: Text('选择班级'),
      onConfirm: (picker, selecteds) {
        // print(selecteds);
        this.setState(() {
         _health.className = _bindClass[selecteds[0]]['className'];
          _health.classId = _bindClass[selecteds[0]]['classId'];
        });
      },
    );
    picker.show(_scaffoldKey.currentState);
  }
  void openSearch() {
    if(_health.className!=null){
      // print('params:${_health.classId}');
      Navigator.of(context).pushNamed('/searchStudent',arguments: Argument(params:_health.classId));

    }else{
      FLToast.info(text:'请选择班级');
    }
  }
}