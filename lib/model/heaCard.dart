import 'package:json_annotation/json_annotation.dart';
part 'heaCard.g.dart';
@JsonSerializable()
class HealthCard{
  String address;
  String userNum;
  String phone;
  String name;
  String id;
  String idCard;
  /*不适*/ 
  String isDiscomfort;
  /*发热*/ 
  String isPyrexia;
  /*隔离*/ 
  String isQuarantine;
  /*疑似*/ 
  String isSuspected;

  String faceUrl;

  String faceFile;

  String stuNum;

  String status;

  String createTime;
  HealthCard({
    this.address,
    this.userNum,
    this.id,this.idCard,
    this.isDiscomfort,
    this.isPyrexia,
    this.isQuarantine,
    this.isSuspected,
    this.name,
    this.phone,
    this.faceFile,
    this.faceUrl,
    this.status,
    this.stuNum,
    this.createTime
  });
  factory HealthCard.fromJson(Map<String,dynamic> json)=>_$HealthCardFromJson(json);
  Map<String,dynamic> toJson()=>_$HealthCardToJson(this);
}