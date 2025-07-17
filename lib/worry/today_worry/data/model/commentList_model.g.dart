// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commentList_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentListResponse _$CommentListResponseFromJson(Map<String, dynamic> json) =>
    CommentListResponse(
      comments: (json['comments'] as List<dynamic>)
          .map((e) => Comment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CommentListResponseToJson(
        CommentListResponse instance) =>
    <String, dynamic>{
      'comments': instance.comments,
    };
