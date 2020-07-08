import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:health/model/dictionary.dart';
import 'package:health/model/global.dart';
import 'package:health/model/leaveForm.dart';
import 'package:health/service/index.dart';
import 'package:health/widget/index.dart';

class LeaveApply extends StatefulWidget {
  final String title = '学生请假';
  @override
  _LeaveApplyState createState() => _LeaveApplyState();
}

class _LeaveApplyState extends State<LeaveApply> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = new GlobalKey();
  LeaveForm leaveForm = new LeaveForm();
  List leaveType =
      Dictionary.getByUniqueName(UniqueNameValues[UNIQUE_NAME.LEAVETYPE]);
  String leaveTypeValue = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          InkWell(
            child: Icon(Icons.menu),
            onTap: () {
              Navigator.of(context).pushNamed('/leaveList');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: form(),
      ),
    );
  }

  Widget form() {
    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // ListTile(
            //   title: Text('请假类型'),
            //   // trailing: ,
            //   onTap: _showPicker,
            // ),
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
              title: Text('请假类型:'),
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
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text('请假事由:',
                    style: Theme.of(context).textTheme.subtitle1)),
            TextFormField(
                maxLines: 8,
                autofocus: false,
                decoration: InputDecoration(
                  hintText: '输入理由',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                ),
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
      leaveForm.userId = Global.profile.user.id;
      leaveForm.orgId = Global.profile.user.organId;
      leaveForm.userName = Global.profile.user.userName;
      leaveForm.userNum = Global.profile.user.loginName;
      leaveForm.personType = Global.profile.user.personType;

      var res = await leaveApply(leaveForm);
      if (res != null && res['code'] == 0) {
        Navigator.of(context).pushNamed('/leaveList');
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
}
