import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';
@JsonSerializable()
class User{
  /*--id*/ 
  String id;
  
  /*用户名*/ 
  String userName;
  /*用户性别*/ 
  String gender;
  /*头像*/  
  String photo;
  /*电话*/ 
  String phone;
  /*组织名称*/
  String organName;
  /*证件信息*/  
  String credNum;
  /*organId*/ 
  String organId;
  /*schName*/ 
  String schName;
  /*schLogo*/
  String schLogo;
  /*personType*/ 
  String personType;
  /*roleNames*/ 
  List roleNames;
  /*账号*/
  String loginName;
  
  User({
    this.id,this.userName,this.gender,this.photo,this.phone,this.credNum,
    this.organId,this.organName,this.personType,this.roleNames,this.schLogo,
    this.schName,this.loginName
  });
  factory User.fromJson(Map<String,dynamic> json)=>_$UserFromJson(json);
  Map<String, dynamic> toJson()=>_$UserToJson(this);
}