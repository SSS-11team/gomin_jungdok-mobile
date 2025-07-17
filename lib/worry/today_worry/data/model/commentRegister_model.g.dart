// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commentRegister_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentRequest _$CommentRequestFromJson(Map<String, dynamic> json) =>
    CommentRequest(
      description: json['description'] as String,
      parentCommentId: (json['parentCommentId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CommentRequestToJson(CommentRequest instance) =>
    <String, dynamic>{
      'description': instance.description,
      'parentCommentId': instance.parentCommentId,
    };
