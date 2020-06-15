import 'package:flutter/material.dart';

class LeaveApply extends StatefulWidget {
  final String title = '学生请假';
  @override
  _LeaveApplyState createState() => _LeaveApplyState();
}

class _LeaveApplyState extends State<LeaveApply> {
  final GlobalKey<FormState> formKey = new GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(),
      ),
    );
  }
  Widget form(){
    return Form(
      key: formKey,
      child: Column(
        
      ),);
  }
}