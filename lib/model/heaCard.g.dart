// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heaCard.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthCard _$HealthCardFromJson(Map<String, dynamic> json) {
  return HealthCard(
    address: json['address'] as String,
    userNum: json['userNum'] as String,
    id: json['id'] as String,
    idCard: json['idCard'] as String,
    isDiscomfort: json['isDiscomfort'] as String,
    isPyrexia: json['isPyrexia'] as String,
    isQuarantine: json['isQuarantine'] as String,
    isSuspected: json['isSuspected'] as String,
    name: json['name'] as String,
    phone: json['phone'] as String,
    faceFile: json['faceFile'] as String,
    faceUrl: json['faceUrl'] as String,
    status: json['status'] as String,
    stuNum: json['stuNum'] as String,
    createTime: json['createTime'] as String,
    personType: json['personType'] as String,
  );
}

Map<String, dynamic> _$HealthCardToJson(HealthCard instance) =>
    <String, dynamic>{
      'address': instance.address,
      'userNum': instance.userNum,
      'phone': instance.phone,
      'name': instance.name,
      'id': instance.id,
      'idCard': instance.idCard,
      'isDiscomfort': instance.isDiscomfort,
      'isPyrexia': instance.isPyrexia,
      'isQuarantine': instance.isQuarantine,
      'isSuspected': instance.isSuspected,
      'faceUrl': instance.faceUrl,
      'faceFile': instance.faceFile,
      'stuNum': instance.stuNum,
      'status': instance.status,
      'createTime': instance.createTime,
      'personType': instance.personType,
    };
