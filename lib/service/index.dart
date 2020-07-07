import 'package:dio/dio.dart';
import 'package:health/model/heaCard.dart';
import 'package:health/model/heaSafety.dart';
import 'package:health/model/health.dart';
import 'package:health/model/leaveForm.dart';
// import 'package:health/model/leaveForm.dart';
import 'package:health/model/news.dart';
import 'package:health/model/pagination.dart';
import 'package:health/model/student.dart';
import './instance.dart';
import './api.dart';

login({String loginName, String password}) {
  return DioManager().post(Api.login,
      data: {'loginName': loginName, 'password': password}, loading: true);
}

loginOut() {
  return DioManager().post(Api.loginOut);
}

healthReport(Health health) {
  // print('healthpersonType:${health.personType}');
  return DioManager()
      .post(Api.heaInfoDailyInsert, data: filterEmpty(health.toJson()));
}

getDicts() {
  return DioManager().post(Api.getDics);
}

getStudentList({Student stu, Pagination pagination}) {
  Map a = stu.toJson();
  a.addAll(pagination.toJson());
  // print(filterEmpty(a));
  return DioManager()
      .post(Api.getStuList, data: filterEmpty(a), loading: false);
}

healthList({Health health, Pagination pagination}) {
  Map a = health.toJson();
  a.addAll(pagination.toJson());
  print(filterEmpty(a));
  return DioManager()
      .post(Api.heaInfoDailyList, data: filterEmpty(a), loading: false);
}

/*晨午检删除*/
healthDelete(String id) {
  return DioManager().post(Api.heaInfoDailyDelete, data: {"id": id});
}

/*平安上报-添加*/
safetyReport(HeaSafety heaSafety) {
  return DioManager()
      .post(Api.insertHeaDaily, data: filterEmpty(heaSafety.toJson()));
}

safetyList(String checkDate, String classId) {
  return DioManager().post(Api.listHeaDaily,
      data: {"checkDate": checkDate, "classId": classId}, loading: false);
}

/*请假-列表*/
getLeaveList(
    {Pagination pagination,
    String createUserId,
    String personType,
    String status}) {
  Map a = pagination.toJson();
  Map<String, dynamic> b = {
    "createUserId": createUserId,
    "personType": personType,
    "status": status
  };
  a.addAll(b);

  return DioManager().post(Api.leaveList, data: a, loading: false);
}

/*请假-审批*/
approvalLeave({String id, String status}) {
  return DioManager()
      .post(Api.leaveApproval, data: {'id': id, 'status': status});
}

/*请假申请*/
leaveApply(LeaveForm leaveForm) {
  FormData formData;
  Map a = leaveForm.toJson();
  if (leaveForm.filePaths != null && leaveForm.filePaths.length > 0) {
    // Map b = a.addAll(other)
    formData = FormData.fromMap({
      ...a,
      "file": leaveForm.filePaths
          .map((e) async => await MultipartFile.fromFile(e))
          .toList()
    });
  } else {
    formData = FormData.fromMap(leaveForm.toJson());
  }
  return DioManager().post(Api.applicationLeave, data: formData);
}

/*通知列表*/
getNewsList({News news, Pagination pagination}) {
  Map a = pagination.toJson();
  if (news != null) {
    a.addAll(news.toJson());
  }
  return DioManager().post(Api.newsList, data: filterEmpty(a), loading: false);
}

/*健康卡-提交*/
heaCardAdd(HealthCard healthCard) {
  return DioManager()
      .post(Api.heaInfoCardInsert, data: filterEmpty(healthCard.toJson()));
}

/*健康卡列表*/
heaCardList({HealthCard healthCard, Pagination pagination}) {
  Map a = pagination.toJson();
  if (healthCard != null) {
    a.addAll(healthCard.toJson());
  }
  print('a:${filterEmpty(a)}');
  return DioManager()
      .post(Api.heaInfoCardList, data: filterEmpty(a), loading: false);
}

/*健康信息上报*/
healthInfoReport({Health health}) {
  print('_health:${filterEmpty(health.toJson())}');
  return DioManager()
      .post(Api.heaInfoDailyParent, data: filterEmpty(health.toJson()));
}

//每日状态
checkHasReport({String reportDay, String id, String name}) {
  return DioManager().post(Api.listDaily,
      data: {
        'reportStartTime': reportDay,
        'reportEndTime': reportDay,
        'id': id,
        'name': name
      },
      loading: false);
}

Map filterEmpty(Map s) {
  Map t = {};
  s.forEach((key, value) {
    if (s[key] != null) {
      t[key] = s[key];
    }
  });
  return t;
}
