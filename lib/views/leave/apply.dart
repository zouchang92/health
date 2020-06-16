import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:health/model/global.dart';
import 'package:health/model/leaveForm.dart';
// import 'package:health/service/index.dart';
import 'package:health/widget/index.dart';

class LeaveApply extends StatefulWidget {
  final String title = '学生请假';
  @override
  _LeaveApplyState createState() => _LeaveApplyState();
}

class _LeaveApplyState extends State<LeaveApply> {
  final GlobalKey<FormState> formKey = new GlobalKey();
  LeaveForm leaveForm = new LeaveForm();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          InkWell(
            child: Icon(Icons.menu),
            onTap: (){
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
                showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)))
                    .then((value) => {
                          this.setState(() {
                            if (value != null) {
                              leaveForm.startTime =
                                  formatDate(value, [yyyy, '-', mm, '-', dd]);
                            }
                          })
                        });
              },
            ),
            Divider(height: 1),
            ListTile(
              title: Text('结束时间:'),
              trailing: Text(leaveForm.endTime ?? ''),
              onTap: () {
                showDatePicker(
                        context: context,
                        initialDate: leaveForm.startTime != null
                            ? DateTime.parse(leaveForm.startTime)
                            : DateTime.now(),
                        firstDate: leaveForm.startTime != null
                            ? DateTime.parse(leaveForm.startTime)
                            : DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)))
                    .then((value) => {
                          if (value != null)
                            {
                              this.setState(() {
                                leaveForm.endTime =
                                    formatDate(value, [yyyy, '-', mm, '-', dd]);
                              })
                            }
                        });
              },
            ),
            Container(
              height: 10,
              color: Color(0xffe4e4e4),
            ),
            TextFormField(
                maxLines: 8,
                decoration: InputDecoration(
                    hintText: '输入理由',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        child: Text('请假事由:')),
                    prefixIconConstraints: BoxConstraints()),
                onSaved: (val) {
                  leaveForm.reason = val;
                }),
            Container(
              height: 10,
              color: Color(0xffe4e4e4),
            ),
            ImagePickerWidget(
              onValueChange: (File file) {
                print('file:${file.path}');
                this.setState(() {
                  leaveForm.file = [file];
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

  Future _applicationLeave() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      leaveForm.userId = Global.profile.user.id;
      leaveForm.orgId = Global.profile.user.organId;
      leaveForm.userName = Global.profile.user.userName;
      leaveForm.userNum = '2433';
      // print('leaveForm:${leaveForm.toJson()}');
      // await applyLeave(leaveForm);
      
    }
  }
}
