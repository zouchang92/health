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

  String personType;

  String jobNum;

  String className;

  String classId;

  
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
    this.createTime,
    this.personType,
    this.jobNum,
    this.className,
    this.classId
  });
  factory HealthCard.fromJson(Map<String,dynamic> json)=>_$HealthCardFromJson(json);
  Map<String,dynamic> toJson()=>_$HealthCardToJson(this);
}