// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nuclecReport.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NuclecReport _$NuclecReportFromJson(Map<String, dynamic> json) {
  return NuclecReport(
    checkTime: json['checkTime'] as String,
    className: json['className'] as String,
    classId: json['classId'] as String,
    confirmEndTime: json['confirmEndTime'] as String,
    currentTimes: json['currentTimes'] as String,
    heaInfoDailyNATDTOList: json['heaInfoDailyNATDTOList'] as String,
    hs: json['hs'] as String,
    igG: json['igG'] as String,
    igM: json['igM'] as String,
    report: json['report'] as String,
    totalTimes: json['totalTimes'] as String,
    name: json['name'] as String,
    personType: json['personType'] as String,
    stuNum: json['stuNum'] as String,
    faceUrl: json['faceUrl'] as String,
    checkResult: json['checkResult'] as String,
    gender: json['gender'] as String,
  )..confirmStartTime = json['confirmStartTime'] as String;
}

Map<String, dynamic> _$NuclecReportToJson(NuclecReport instance) =>
    <String, dynamic>{
      'faceUrl': instance.faceUrl,
      'checkResult': instance.checkResult,
      'checkTime': instance.checkTime,
      'classId': instance.classId,
      'className': instance.className,
      'confirmEndTime': instance.confirmEndTime,
      'confirmStartTime': instance.confirmStartTime,
      'currentTimes': instance.currentTimes,
      'heaInfoDailyNATDTOList': instance.heaInfoDailyNATDTOList,
      'hs': instance.hs,
      'igG': instance.igG,
      'igM': instance.igM,
      'report': instance.report,
      'totalTimes': instance.totalTimes,
      'name': instance.name,
      'personType': instance.personType,
      'stuNum': instance.stuNum,
      'gender': instance.gender,
    };
