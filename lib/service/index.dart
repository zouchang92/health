
import 'package:health/model/health.dart';
import 'package:health/model/pagination.dart';
import 'package:health/model/student.dart';

import './instance.dart';
import './api.dart';
login({String loginName, String password}){
  return DioManager().post(Api.login,data: {
    'loginName':loginName,
    'password':password
  });
}

healthReport(Health health){
  print(health.toJson());
  return DioManager().post(Api.heaInfoDailyInsert,data:health.toJson());
}

getDicts(){
  return DioManager().post(Api.getDics);
}

getStudentList({Student stu,Pagination pagination}){
  Map a = stu.toJson();
  a.addAll(pagination.toJson());
  return DioManager().post(Api.getStuList,data:a,loading: false);
}