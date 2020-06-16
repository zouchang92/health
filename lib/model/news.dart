import 'package:json_annotation/json_annotation.dart';
part 'news.g.dart';
@JsonSerializable()
class News{
  String cover;
  String content;
  String title;
  String publishTime;
  String id;
  String newType;
  String updateTime;
  String createTime;
  String approverTime;
  News({this.content,this.approverTime,this.cover,this.createTime,this.id,
  this.newType,this.publishTime,this.title,this.updateTime});
  factory News.fromJson(Map<String,dynamic> json)=>_$NewsFromJson(json);
  Map<String,dynamic> toJson()=> _$NewsToJson(this);
  
}