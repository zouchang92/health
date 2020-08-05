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
    heaInfoDailyNATDTOLisths: json['heaInfoDailyNATDTOLisths'] as String,
    igG: json['igG'] as String,
    igM: json['igM'] as String,
    report: (json['report'] as List)?.map((e) => e as String)?.toList(),
    totalTimes: json['totalTimes'] as String,
    name: json['name'] as String,
    personType: json['personType'] as String,
    stuNum: json['stuNum'] as String,
  )..confirmStartTime = json['confirmStartTime'] as String;
}

Map<String, dynamic> _$NuclecReportToJson(NuclecReport instance) =>
    <String, dynamic>{
      'checkTime': instance.checkTime,
      'classId': instance.classId,
      'className': instance.className,
      'confirmEndTime': instance.confirmEndTime,
      'confirmStartTime': instance.confirmStartTime,
      'currentTimes': instance.currentTimes,
      'heaInfoDailyNATDTOLisths': instance.heaInfoDailyNATDTOLisths,
      'igG': instance.igG,
      'igM': instance.igM,
      'report': instance.report,
      'totalTimes': instance.totalTimes,
      'name': instance.name,
      'personType': instance.personType,
      'stuNum': instance.stuNum,
    };
