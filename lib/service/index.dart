import 'package:dio/dio.dart';
import 'package:health/model/heaCard.dart';
import 'package:health/model/heaSafety.dart';
import 'package:health/model/health.dart';
import 'package:health/model/leaveForm.dart';
// import 'package:health/model/leaveForm.dart';
import 'package:health/model/news.dart';
import 'package:health/model/nuclecReport.dart';
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
  // print('和阿阿凯:${filterEmpty(a)}');
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
checkHasReport({String reportDay, String id, String personType}) {
  print(reportDay);
  return DioManager().post(Api.listDaily,
      data: {
        'reportStartTime': reportDay,
        'reportEndTime': reportDay,
        // 'id': id,

        'personType': '1'
      },
      loading: false);
}

//上报查询
getHealthInfoReportList({Health health, Pagination pagination}) {
  Map a = pagination.toJson();
  if (health != null) {
    a.addAll(health.toJson());
  }
  // print(filterEmpty(a));
  return DioManager().post(Api.listDaily, data: filterEmpty(a), loading: false);
}

//学生核酸信息查询
getStuHea({Pagination pagination}) {
  Map a = pagination.toJson();
  print(filterEmpty(a));
  return DioManager()
      .post(Api.getStuHeaInfo, data: filterEmpty(a), loading: false);
}

/*核酸上报*/
/*方法名称首字母不能大写  看问题会有提示-之前的menuValue里的可以改过来，后面的遵照规则来
  否则问题里太多这样的因为拼写提示的错误会太多 导致你看不到其他问题
*/
nucleicReportList(NuclecReport nuclecReport) {
  return DioManager().post(Api.insterBuclecReportList,
      data: filterEmpty(nuclecReport.toJson()));
}

//确认状态
updateStatus({String id, illStatus}) {
  return DioManager()
      .post(Api.updateStatus, data: {"id": id, 'illStatus': illStatus});
}

insertHeaInfoDaily(String id) {
  return DioManager().post(Api.insertHeaInfoDaily, data: {"id": id});
}

updateAllStatus({String checkResult: '1', id}) {
  return DioManager()
      .post(Api.updateAllStatus, data: {"ids": id, checkResult: '1'});
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
