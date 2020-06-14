
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
  // print('healthpersonType:${health.personType}');
  return DioManager().post(Api.heaInfoDailyInsert,data:filterEmpty(health.toJson()));
}

getDicts(){
  return DioManager().post(Api.getDics,loading: false);
}

getStudentList({Student stu,Pagination pagination}){
  Map a = stu.toJson();
  a.addAll(pagination.toJson());
  return DioManager().post(Api.getStuList,data:a,loading: false);
}

healthList({Health health,Pagination pagination}){
   Map a = health.toJson();
   a.addAll(pagination.toJson());
   return DioManager().post(Api.heaInfoDailyList,data:filterEmpty(a),loading: false);
}

/*晨午检删除*/ 
healthDelete(String id){
   return DioManager().post(Api.heaInfoDailyDelete,data: {"id":id});
}

Map filterEmpty(Map s){
  Map t = {};
  s.forEach((key, value) {
     if(s[key]!=null){
       t[key] = s[key];
     }
  });
  return t;
}