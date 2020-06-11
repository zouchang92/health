import 'package:json_annotation/json_annotation.dart';
part 'health.g.dart';
@JsonSerializable()
class Health{
  /*地址*/
  String address;
  /*时间*/ 
  String approveTime;

  String checkPersonType;

  String checkResult;

  String checkType;

  String city;

  String cityName;

  String classId;

  String className;

  String confirmTime;

  String county;

  String countyName;

  String createOrgId;

  String createUserId;

  String department;

  String departmentName;

  String discomfortDesp;

  String division;

  String divisionName;

  String gender;

  String grade;

  String gradeName;

  String heaId;

  String id;

  List<String> ids;

  String illStatus;

  String isContactSuspect;

  String isDiscomfort;

  String isDiscomfortHome;

  String isDiscomfortPart;

  String isQuarantine;

  String jobNum;

  String name;

  String personType;

  String phone;

  String province;

  String provinceName;

  String reportTime;

  String schoolName;

  String stuNum;

  String illDate;

  String illType;

  String isHealed;

  String healDate;

  String healHospital;

  /*采取措施*/ 
  String memo;
  /*登记类型*/
  String type; 
  /*离校日期*/ 
  String leaveDate;
  
  
  Health({this.address,this.approveTime,this.checkPersonType,this.checkResult,this.checkType,
    this.city,this.cityName,this.classId,this.className,this.confirmTime,this.county,this.countyName,
    this.createOrgId,this.createUserId,this.department,this.departmentName,this.discomfortDesp,
    this.division,this.divisionName,this.gender,this.grade,this.gradeName,this.heaId,this.id,
    this.ids,this.illStatus,this.isContactSuspect,this.isDiscomfort,this.isDiscomfortHome,
    this.isDiscomfortPart,this.isQuarantine,this.jobNum,this.name,this.personType,this.phone,
    this.province,this.provinceName,this.reportTime,this.schoolName,this.stuNum,this.healDate,
    this.healHospital,this.illDate,this.illType,this.isHealed,this.leaveDate,this.memo,this.type
  });
  factory Health.fromJson(Map<String,dynamic> json)=>_$HealthFromJson(json);
  Map<String, dynamic> toJson()=>_$HealthToJson(this);
}