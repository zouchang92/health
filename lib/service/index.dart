
import 'package:health/model/health.dart';

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