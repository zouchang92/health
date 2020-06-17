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
  
  // List<MultipartFile> file;
  List<String> filePaths;
  LeaveForm({this.startTime,this.endTime,this.orgId,this.reason,
    this.userId,this.userName,this.userNum,this.filePaths
  });
  factory LeaveForm.fromJson(Map<String,dynamic> json)=>_$LeaveFormFromJson(json);
  Map<String,dynamic> toJson()=>_$LeaveFormToJson(this);

  
}