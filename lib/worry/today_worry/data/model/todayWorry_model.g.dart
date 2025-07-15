// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todayWorry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodayWorry _$TodayWorryFromJson(Map<String, dynamic> json) => TodayWorry(
      postId: (json['postId'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      voteResults:
          VoteResults.fromJson(json['voteResults'] as Map<String, dynamic>),
      totalVoteCount: (json['totalVoteCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
    );

Map<String, dynamic> _$TodayWorryToJson(TodayWorry instance) =>
    <String, dynamic>{
      'postId': instance.postId,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'voteResults': instance.voteResults,
      'totalVoteCount': instance.totalVoteCount,
      'commentCount': instance.commentCount,
    };
