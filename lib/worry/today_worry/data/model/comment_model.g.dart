// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) => Comment(
      id: (json['id'] as num).toInt(),
      profileImage: json['profileImage'] as String,
      nickname: json['nickname'] as String,
      description: json['description'] as String,
      parentCommentId: (json['parentCommentId'] as num).toInt(),
      createdAt: json['createdAt'] as String,
      hierarchy: (json['hierarchy'] as num).toInt(),
      isMine: json['isMine'] as bool,
    );

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'profileImage': instance.profileImage,
      'nickname': instance.nickname,
      'description': instance.description,
      'parentCommentId': instance.parentCommentId,
      'createdAt': instance.createdAt,
      'hierarchy': instance.hierarchy,
      'isMine': instance.isMine,
    };
