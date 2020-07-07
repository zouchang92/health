import 'package:json_annotation/json_annotation.dart';
part 'leaveForm.g.dart';

@JsonSerializable()
class LeaveForm {
  String startTime;
  String endTime;
  String orgId;
  String userName;
  String userId;
  String userNum;
  String reason;
  String status;
  String personType;
  String type;
  List<String> filePaths;
  LeaveForm(
      {this.startTime,
      this.endTime,
      this.orgId,
      this.reason,
      this.userId,
      this.userName,
      this.userNum,
      this.filePaths,
      this.status,
      this.personType,
      this.type});
  factory LeaveForm.fromJson(Map<String, dynamic> json) =>
      _$LeaveFormFromJson(json);
  Map<String, dynamic> toJson() => _$LeaveFormToJson(this);
}
