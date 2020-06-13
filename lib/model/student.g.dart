// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) {
  return Student(
    classId: json['classId'] as String,
    orgCode: json['orgCode'] as String,
    organId: json['organId'] as String,
    school: json['school'] as String,
    schoolName: json['schoolName'] as String,
    className: json['className'] as String,
    credNum: json['credNum'] as String,
    gender: json['gender'] as String,
    id: json['id'] as String,
    ids: (json['ids'] as List)?.map((e) => e as String)?.toList(),
    studentName: json['studentName'] as String,
    studentNum: json['studentNum'] as String,
  );
}

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'id': instance.id,
      'ids': instance.ids,
      'organId': instance.organId,
      'orgCode': instance.orgCode,
      'gender': instance.gender,
      'classId': instance.classId,
      'className': instance.className,
      'studentName': instance.studentName,
      'studentNum': instance.studentNum,
      'school': instance.school,
      'schoolName': instance.schoolName,
      'credNum': instance.credNum,
    };
