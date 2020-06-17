import 'package:dio/dio.dart';
import 'package:health/model/heaCard.dart';
import 'package:health/model/heaSafety.dart';
import 'package:health/model/health.dart';
// import 'package:health/model/leaveForm.dart';
import 'package:health/model/news.dart';
import 'package:health/model/pagination.dart';
import 'package:health/model/student.dart';
import 'package:health/model/user.dart';


import './instance.dart';
import './api.dart';
login({String loginName, String password}){
  return DioManager().post(Api.login,data: {
    'loginName':loginName,
    'password':password
  });
}

loginOut(){
  return DioManager().post(Api.loginOut);
}

healthReport(Health health){
  // print('healthpersonType:${health.personType}');
  return DioManager().post(Api.heaInfoDailyInsert,data:filterEmpty(health.toJson()));
}

getDicts(){
  return DioManager().post(Api.getDics);
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


/*平安上报-添加*/
safetyReport(HeaSafety heaSafety){
  return DioManager().post(Api.insertHeaDaily,data: filterEmpty(heaSafety.toJson()));
}

safetyList(String checkDate){
  
  
 return DioManager().post(Api.listHeaDaily,data:{"checkDate":checkDate},loading: false);
}

/*请假-列表*/
getLeaveList({Pagination pagination,User user}){
  Map a = user.toJson();
  a.addAll(pagination.toJson());
  return DioManager().post(Api.leaveList,data:filterEmpty(a),loading: false);
} 

/*请假申请*/ 
//  applyLeave({String startTime,String endTime,String userName,String userId,String userNum,String reason,String filePath}){
//    FormData formData = FormData.fromMap({
//      "startTime":startTime,
//      "endTime":endTime,
//      "userName":userName,
//      "userId":userId,
//      "userNum":userNum,
//      "reason":reason,
//      "file":await MultipartFile.fromFile(filePath)
//    });
   
//  }

/*通知列表*/
getNewsList({News news,Pagination pagination}){
  Map a = news.toJson();
  a.addAll(pagination.toJson());
  return DioManager().post(Api.newsList,data:filterEmpty(a));
} 
/*健康卡-提交*/ 
heaCardAdd(HealthCard healthCard){
  return DioManager().post(Api.heaInfoCardInsert,data:filterEmpty(healthCard.toJson()));
}

/*健康卡列表*/ 
heaCardList({HealthCard healthCard,Pagination pagination}){
  Map a = healthCard.toJson();
  a.addAll(pagination.toJson());
  return DioManager().post(Api.heaInfoCardList,data: filterEmpty(a),loading: false);
}
/*文件上传*/ 
// _uploadFile(File file){
//   String path = file.path;
//   String name = path.substring(path.lastIndexOf("/") + 1, path.length);
//   String suffix = path.substring(path.lastIndexOf(".") + 1, path.length);
//   FormData formData = new FormData(file:);
//   return DioManager().post(Api.uploadFile);
// }




Map filterEmpty(Map s){
  Map t = {};
  s.forEach((key, value) {
     if(s[key]!=null){
       t[key] = s[key];
     }
  });
  return t;
}