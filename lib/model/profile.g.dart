// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) {
  return Profile(
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    lastLoginTime: json['lastLoginTime'] == null
        ? null
        : DateTime.parse(json['lastLoginTime'] as String),
    isLogin: json['isLogin'] as bool,
    isChecked: json['isChecked'] as bool,
    lastLoginAcount: json['lastLoginAcount'] as String,
    lastLoginPassword: json['lastLoginPassword'] as String,
    token: json['token'] as String,
  );
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'user': instance.user,
      'lastLoginTime': instance.lastLoginTime?.toIso8601String(),
      'isLogin': instance.isLogin,
      'isChecked': instance.isChecked,
      'lastLoginAcount': instance.lastLoginAcount,
      'lastLoginPassword': instance.lastLoginPassword,
      'token': instance.token,
    };
