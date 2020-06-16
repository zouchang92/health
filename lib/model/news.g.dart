// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

News _$NewsFromJson(Map<String, dynamic> json) {
  return News(
    content: json['content'] as String,
    approverTime: json['approverTime'] as String,
    cover: json['cover'] as String,
    createTime: json['createTime'] as String,
    id: json['id'] as String,
    newType: json['newType'] as String,
    publishTime: json['publishTime'] as String,
    title: json['title'] as String,
    updateTime: json['updateTime'] as String,
  );
}

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'cover': instance.cover,
      'content': instance.content,
      'title': instance.title,
      'publishTime': instance.publishTime,
      'id': instance.id,
      'newType': instance.newType,
      'updateTime': instance.updateTime,
      'createTime': instance.createTime,
      'approverTime': instance.approverTime,
    };
