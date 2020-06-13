import 'package:json_annotation/json_annotation.dart';
part 'student.g.dart';
@JsonSerializable()
class Student{
  String id;

  List<String> ids;

  String organId;

  String orgCode;

  String gender;

  String classId;

  String className;

  String studentName;

  String studentNum;

  String school;

  String schoolName;

  String credNum;
  Student({
    this.classId,this.orgCode,this.organId,this.school,this.schoolName,
    this.className,this.credNum,this.gender,this.id,this.ids,this.studentName,
    this.studentNum
  });
  factory Student.fromJson(Map<String,dynamic> json)=> _$StudentFromJson(json);
  Map<String,dynamic> toJson()=>_$StudentToJson(this);

}