// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaveForm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveForm _$LeaveFormFromJson(Map<String, dynamic> json) {
  return LeaveForm(
    startTime: json['startTime'] as String,
    endTime: json['endTime'] as String,
    orgId: json['orgId'] as String,
    password: json['password'] as String,
    reason: json['reason'] as String,
    userId: json['userId'] as String,
    userName: json['userName'] as String,
    userNum: json['userNum'] as String,
  );
}

Map<String, dynamic> _$LeaveFormToJson(LeaveForm instance) => <String, dynamic>{
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'orgId': instance.orgId,
      'userName': instance.userName,
      'userId': instance.userId,
      'userNum': instance.userNum,
      'reason': instance.reason,
      'password': instance.password,
    };
