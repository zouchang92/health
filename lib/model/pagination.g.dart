// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pagination _$PaginationFromJson(Map<String, dynamic> json) {
  return Pagination(
    page: json['page'] as int,
    rows: json['rows'] as int,
    totalCount: json['totalCount'] as int,
    currPage: json['currPage'] as int,
    pageSize: json['pageSize'] as int,
    totalPage: json['totalPage'] as int,
  );
}

Map<String, dynamic> _$PaginationToJson(Pagination instance) =>
    <String, dynamic>{
      'page': instance.page,
      'rows': instance.rows,
      'totalCount': instance.totalCount,
      'pageSize': instance.pageSize,
      'totalPage': instance.totalPage,
      'currPage': instance.currPage,
    };
