// import 'package:flutter/material.dart';

import '../views/index.dart';
final routes = {
  '/':(context)=>Home(),
  '/login':(context)=>Login(),
  '/safetyReport':(context)=>SafetyReport(),
  '/healthReport':(context)=>HealthReport(),
  '/searchStudent':(context)=>ContactList(),
  
  '/healthSelect':(context)=>HealthSelect(),
  '/healthSelectSym':(context)=>SelectSym(),
  '/healthSelectIll':(context)=>SelectIll(),
  '/healthList':(context)=>HealthList(),
  '/leaveList':(context)=>LeaveList(),
  '/healthCardList':(context)=>HealthCardList()
};