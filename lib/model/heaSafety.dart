import 'package:json_annotation/json_annotation.dart';
part 'heaSafety.g.dart';
@JsonSerializable()
class HeaSafety{
  String className;
  String classId;
  /*出勤人数*/ 
  int cqTotal ;
  /*发热人数*/ 
  int frTotal ;
  /*请假人数*/ 
  int qjTotal ;
  /*总人数*/ 
  int total ;
  /*伤害人数*/ 
  int shTotal ;
  /*班级状态*/ 
  int status;
  /*体温正常人数*/ 
  int zcTotal ;
  
  
  HeaSafety({this.classId,this.className,this.cqTotal,this.frTotal,this.qjTotal,
    this.shTotal,this.status,this.total,this.zcTotal
  }){
    this.total = this.total??0;
    this.frTotal = this.frTotal??0;
    this.cqTotal = this.cqTotal??0;
    this.qjTotal = this.qjTotal??0;
    this.shTotal = this.shTotal??0;
    this.zcTotal = this.zcTotal??0;
  }
  factory HeaSafety.fromJson(Map<String,dynamic> json)=> _$HeaSafetyFromJson(json);
  Map<String,dynamic> toJson()=> _$HeaSafetyToJson(this);

  
}