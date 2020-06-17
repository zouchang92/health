// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../views/index.dart';
final routes = {
  '/':(context)=>Home(),
  '/login':(context)=>Login(),
  '/safetyReport':(context)=>SafetyReport(),
  '/healthReport':(context)=>HealthReport(),
  '/searchStudent':(context)=>ContactList(argument: ModalRoute.of(context).settings.arguments),
  
  '/healthSelect':(context)=>HealthSelect(),
  '/healthSelectSym':(context)=>SelectSym(),
  '/healthSelectIll':(context)=>SelectIll(),
  '/healthList':(context)=>HealthList(),
  '/leaveList':(context)=>LeaveList(),
  '/healthCardList':(context)=>HealthCardList(),
  '/healthDetail':(context)=>HealthDetail(),
  '/healthCardReport':(context)=>HealthCardReport(),
  '/safetyList':(context)=>SafetyList(),
  '/leaveApply':(context)=>LeaveApply(),
  '/healthCardDetail':(context)=>HealthCardDetail(argument: ModalRoute.of(context).settings.arguments),
  '/approvalLeaveList':(context)=>LeaveApprovalList(),
  '/leaveDateil':(context)=>LeaveDetail(arg:ModalRoute.of(context).settings.arguments),
  '/LeaveApplyForStudent':(context)=>LeaveApplyForStudent(args: ModalRoute.of(context).settings.arguments),
  '/newsList':(context)=>NewsList(),
  '/newsDetail':(context)=>NewsDetail(args: ModalRoute.of(context).settings.arguments)
};