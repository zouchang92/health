import 'package:json_annotation/json_annotation.dart';
part 'leaveForm.g.dart';
@JsonSerializable()
class LeaveForm{
  String startTime;
  String endTime;
  String orgId;
  String userName;
  String userId;
  String userNum;
  String reason;
  String password;
  // StringBuffer file;
  LeaveForm({this.startTime,this.endTime,this.orgId,this.password,this.reason,
    this.userId,this.userName,this.userNum
  });
  factory LeaveForm.fromJson(Map<String,dynamic> json)=>_$LeaveFormFromJson(json);
  Map<String,dynamic> toJson()=> _$LeaveFormToJson(this);
}