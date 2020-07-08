import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flui/flui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:health/model/argument.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';

import 'package:health/model/health.dart';
import 'package:health/model/leaveForm.dart';
import 'package:health/service/index.dart';
import 'package:health/store/profileNotify.dart';
import 'package:health/widget/imagePicker/imagePicker.dart';
import 'package:provider/provider.dart';

class LeaveApplyForStudent extends StatefulWidget {
  final String title = '学生请假';
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
  List _bindClass = Global.profile.user.classIdAndNames ?? [];
  List leaveType =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.LEAVETYPE]);
  String leaveTypeValue = '';
  @override
  void dispose() {
    // _profileNotify.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('leaveType:$leaveType');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: form(),
      ),
    );
  }

  Map getUnempty(Map a) {
    Map b = {};
    a.forEach((key, value) {
      if (value != null) {
        b[key] = a[key];
      }
    });
    return b;
  }

  Widget form() {
    final _arg = Provider.of<ProfileNotify>(context).argValue;
    // print('arg1:${_arg}');
    if (_arg != null) {
      Health _thealth = _arg.params as Health;
      // print('_thealth:${getUnempty(_thealth.toJson())}');
      this.setState(() {
        // _health = Object;
        _health = Health.fromJson(amap(_health.toJson(), _thealth.toJson()));
        leaveForm.userId = _health.id;
        leaveForm.userName = _health.name;
        leaveForm.userNum = _health.stuNum;
        leaveForm.orgId = _health.classId;
        leaveForm.personType = Global.profile.user.personType;
      });
    }
    // Text(_health.className??'')
    return Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('班级选择'),
              trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Text(_health.className ?? ''),
                    Icon(Icons.navigate_next)
                  ]),
              onTap: showClassPicker,
            ),
            Divider(height: 1),
            ListTile(
              title: Text('学生选择'),
              trailing: Wrap(
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
                showPicker('结束时间',
                    minValue: leaveForm.startTime != null
                        ? DateTime.parse(leaveForm.startTime)
                        : null, onConfirm: (Picker picker, selecteds) {
                  print('结束时间:$selecteds');
                  // print('picker:${picker.g}');

                  this.setState(() {
                    if (leaveForm.startTime != null) {
                      int yq = DateTime.parse(leaveForm.startTime).year;
                      leaveForm.endTime =
                          pickerValueFormat(selecteds, start: yq);
                    } else {
                      leaveForm.endTime = pickerValueFormat(selecteds);
                    }
                  });
                });
              },
            ),
            Divider(height: 1),
            ListTile(
              title: Text('请假类型'),
              trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Text(leaveTypeValue ?? ''),
                    Icon(Icons.navigate_next)
                  ]),
              onTap: showLeaveTypePicker,
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
      if (b[key] != null) {
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

      // leaveForm.status = '3';
      // print('leaveForm:${leaveForm.toJson()}');
      try {
        var res = await leaveApply(leaveForm);
        if (res != null && res['code'] == 0) {
          Navigator.of(context).pop();
        }
      } catch (err) {
        print('err:$err');
      }
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
      height: 200,
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

  showLeaveTypePicker() {
    List<PickerItem> _pickerItem =
        leaveType.map((e) => PickerItem(text: Text(e['name']))).toList();
    Picker picker = Picker(
      // itemExtent: 40.0,
      height: 200,
      adapter: PickerDataAdapter(data: _pickerItem),
      title: Text('选择请假类型'),
      onConfirm: (picker, selecteds) {
        // print(selecteds);
        this.setState(() {
          leaveTypeValue = leaveType[selecteds[0]]['name'];
          leaveForm.type = leaveType[selecteds[0]]['code'];
        });
      },
    );
    picker.show(_scaffoldKey.currentState);
  }

  void openSearch() {
    if (_health.className != null) {
      // print('params:${_health.classId}');
      Navigator.of(context).pushNamed('/searchStudent',
          arguments: Argument(params: _health.classId));
    } else {
      FLToast.info(text: '请选择班级');
    }
  }
}
