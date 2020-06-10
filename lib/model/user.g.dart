// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'] as String,
    userName: json['userName'] as String,
    gender: json['gender'] as String,
    photo: json['photo'] as String,
    phone: json['phone'] as String,
    credNum: json['credNum'] as String,
    organId: json['organId'] as String,
    organName: json['organName'] as String,
    personType: json['personType'] as String,
    roleNames: json['roleNames'] as List,
    schLogo: json['schLogo'] as String,
    schName: json['schName'] as String,
    loginName: json['loginName'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'gender': instance.gender,
      'photo': instance.photo,
      'phone': instance.phone,
      'organName': instance.organName,
      'credNum': instance.credNum,
      'organId': instance.organId,
      'schName': instance.schName,
      'schLogo': instance.schLogo,
      'personType': instance.personType,
      'roleNames': instance.roleNames,
      'loginName': instance.loginName,
    };
