// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heaSafety.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeaSafety _$HeaSafetyFromJson(Map<String, dynamic> json) {
  return HeaSafety(
    classId: json['classId'] as String,
    className: json['className'] as String,
    cqTotal: json['cqTotal'] as int,
    frTotal: json['frTotal'] as int,
    qjTotal: json['qjTotal'] as int,
    shTotal: json['shTotal'] as int,
    status: json['status'] as int,
    total: json['total'] as int,
    zcTotal: json['zcTotal'] as int,
  );
}

Map<String, dynamic> _$HeaSafetyToJson(HeaSafety instance) => <String, dynamic>{
      'className': instance.className,
      'classId': instance.classId,
      'cqTotal': instance.cqTotal,
      'frTotal': instance.frTotal,
      'qjTotal': instance.qjTotal,
      'total': instance.total,
      'shTotal': instance.shTotal,
      'status': instance.status,
      'zcTotal': instance.zcTotal,
    };
