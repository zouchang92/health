import 'package:json_annotation/json_annotation.dart';
part 'pagination.g.dart';
@JsonSerializable()
class Pagination{
  int page;
  int rows;
  int totalCount;
  int pageSize;
  int totalPage;
  int currPage;
  Pagination({
    this.page,
    this.rows,
    this.totalCount,
    this.currPage,
    this.pageSize,
    this.totalPage
  });
  factory Pagination.fromJson(Map<String,dynamic> json)=>_$PaginationFromJson(json);
  Map<String, dynamic> toJson() => _$PaginationToJson(this);
}