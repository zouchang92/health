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
    news: json['news'] as List,
    lastLoginAcount: json['lastLoginAcount'] as String,
    lastLoginPassword: json['lastLoginPassword'] as String,
    token: json['token'] as String,
    dictionary: json['dictionary'] as List,
    heaSafetySubTime: json['heaSafetySubTime'] == null
        ? null
        : DateTime.parse(json['heaSafetySubTime'] as String),
  )..heaSafetySubList = (json['heaSafetySubList'] as List)
      ?.map((e) => e as Map<String, dynamic>)
      ?.toList();
}

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
      'user': instance.user,
      'lastLoginTime': instance.lastLoginTime?.toIso8601String(),
      'isLogin': instance.isLogin,
      'isChecked': instance.isChecked,
      'lastLoginAcount': instance.lastLoginAcount,
      'lastLoginPassword': instance.lastLoginPassword,
      'token': instance.token,
      'dictionary': instance.dictionary,
      'heaSafetySubTime': instance.heaSafetySubTime?.toIso8601String(),
      'heaSafetySubList': instance.heaSafetySubList,
      'news': instance.news,
    };
