import 'package:json_annotation/json_annotation.dart';
part 'nuclecReport.g.dart';

@JsonSerializable()
class NuclecReport {
  String faceUrl;

  String checkResult;

  String checkTime;

  String classId;

  String className;

  String confirmEndTime;

  String confirmStartTime;

  String currentTimes;

  String heaInfoDailyNATDTOList;

  String hs;

  String igG;

  String igM;

  // List<String> report;
  String report;

  String totalTimes;

  String name;

  String personType = '1';

  String stuNum;

  String gender;

  NuclecReport(
      {this.checkTime,
      this.className,
      this.classId,
      this.confirmEndTime,
      this.currentTimes,
      this.heaInfoDailyNATDTOList,
      this.hs,
      this.igG,
      this.igM,
      this.report,
      this.totalTimes,
      this.name,
      this.personType,
      this.stuNum,
      this.faceUrl,
      this.checkResult,
      this.gender});
  factory NuclecReport.fromJson(Map<String, dynamic> json) =>
      _$NuclecReportFromJson(json);
  Map<String, dynamic> toJson() => _$NuclecReportToJson(this);
}
