// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'] as String,
    json['userId'] as String,
    json['name'] as String,
    json['gender'] as String,
    json['photo'] as String,
    json['phone'] as String,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'gender': instance.gender,
      'photo': instance.photo,
      'phone': instance.phone,
    };
