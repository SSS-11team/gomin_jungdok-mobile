// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todayWorryDetails_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodayWorryDetails _$TodayWorryDetailsFromJson(Map<String, dynamic> json) =>
    TodayWorryDetails(
      postId: (json['post_id'] as num).toInt(),
      postTitle: json['post_title'] as String,
      postDesc: json['post_desc'] as String,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      voteResults: (json['voteResults'] as List<dynamic>)
          .map((e) => VoteResults.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalVoteCount: (json['totalVoteCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
    );

Map<String, dynamic> _$TodayWorryDetailsToJson(TodayWorryDetails instance) =>
    <String, dynamic>{
      'post_id': instance.postId,
      'post_title': instance.postTitle,
      'post_desc': instance.postDesc,
      'imageUrls': instance.imageUrls,
      'voteResults': instance.voteResults,
      'totalVoteCount': instance.totalVoteCount,
      'commentCount': instance.commentCount,
    };
