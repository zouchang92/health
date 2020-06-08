import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';
@JsonSerializable()
class User{
  /*--id*/ 
  String id;
  /*用户id*/
  String userId; 
  /*用户名*/ 
  String name;
  /*用户性别*/ 
  String gender;
  /*头像*/  
  String photo;
  /*电话*/ 
  String phone;
  User(this.id,this.userId,this.name,this.gender,this.photo,this.phone);
  factory User.fromJson(Map<String,dynamic> json)=>_$UserFromJson(json);
  Map<String, dynamic> toJson()=>_$UserToJson(this);
}