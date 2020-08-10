// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../views/index.dart';

final List<String> keepAliveList = [
  '/healthReport',
  '/LeaveApplyForStudent',
  '/HealthInfoReport',
];
final routes = {
  '/': (context, a, b) => Home(),
  '/login': (context, a, b) => Login(),
  '/safetyReport': (context, a, b) => SafetyReport(),
  '/healthReport': (context, a, b) => HealthReport(),
  '/searchStudent': (context, a, b) =>
      ContactList(argument: ModalRoute.of(context).settings.arguments),
  '/healthSelect': (context, a, b) => HealthSelect(),
  '/healthSelectSym': (context, a, b) => SelectSym(),
  '/healthSelectIll': (context, a, b) => SelectIll(),
  '/healthList': (context, a, b) => HealthList(),
  '/leaveList': (context, a, b) => LeaveList(),
  '/healthCardList': (context, a, b) => HealthCardList(),
  '/healthDetail': (context, a, b) =>
      HealthDetail(arg: ModalRoute.of(context).settings.arguments),
  '/healthCardReport': (context, a, b) =>
      HealthCardReport(args: ModalRoute.of(context).settings.arguments),
  '/safetyList': (context, a, b) => SafetyList(),
  '/leaveApply': (context, a, b) => LeaveApply(),
  '/healthCardDetail': (context, a, b) => HealthCardDetail(),
  '/approvalLeaveList': (context, a, b) => LeaveApprovalList(),
  '/leaveDateil': (context, a, b) =>
      LeaveDetail(arg: ModalRoute.of(context).settings.arguments),
  '/LeaveApplyForStudent': (context, a, b) =>
      LeaveApplyForStudent(args: ModalRoute.of(context).settings.arguments),
  '/newsList': (context, a, b) => NewsList(),
  '/newsDetail': (context, a, b) =>
      NewsDetail(args: ModalRoute.of(context).settings.arguments),
  '/HealthInfoReport': (context, a, b) => HealthInfoReport(),
  '/HealthInfoReportList': (context, a, b) => HealthInfoReportList(),
  '/HealthReportDetail': (context, a, b) =>
      HealthReportDetail(arg: ModalRoute.of(context).settings.arguments),
  '/nucleicReportList': (context, a, b) => NucleicReportList(),
  '/nucleicList': (context, a, b) => NucleicList(),
  '/nucleicRecord': (context, a, b) =>
      NucleicRecord(args: ModalRoute.of(context).settings.arguments),
  '/nucleicDetail': (context, a, b) =>
      NucleicDetail(arg: ModalRoute.of(context).settings.arguments),
  '/nucleicHistory': (context, a, b) => NucleicHistory(),
};
