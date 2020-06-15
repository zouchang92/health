import 'user.dart';
import 'package:json_annotation/json_annotation.dart';
part 'profile.g.dart';
@JsonSerializable()
class Profile{
  /*用户信息-接口相关*/  
   User user;
  /*上次登录时间*/ 
   DateTime lastLoginTime;
  /*是否登录*/  
   bool isLogin;
  /*是否选择记住账号*/  
   bool isChecked;
  /*上次记住登录时账号*/
  String lastLoginAcount;
  /*上次记住登录时密码*/
  String lastLoginPassword; 
  /*token*/ 
  String token;
  /*原始字典数据*/
  List dictionary;
  /*平安上报-提交标记-时间*/ 
  DateTime heaSafetySubTime;
  Profile({this.user,this.lastLoginTime,this.isLogin,this.isChecked,
    this.lastLoginAcount,this.lastLoginPassword,this.token,this.dictionary,this.heaSafetySubTime});
  factory Profile.fromJson(Map<String,dynamic> json)=>_$ProfileFromJson(json);
   Map<String, dynamic> toJson()=> _$ProfileToJson(this);
}