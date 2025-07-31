// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todayWorry_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodayWorry _$TodayWorryFromJson(Map<String, dynamic> json) => TodayWorry(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      option1Content: json['option1Content'] as String,
      option2Content: json['option2Content'] as String,
      option1Vote: (json['option1Vote'] as num).toInt(),
      option2Vote: (json['option2Vote'] as num).toInt(),
      description: json['description'] as String,
      category: json['category'] as String,
      voteResults:
          VoteResults.fromJson(json['voteResults'] as Map<String, dynamic>),
      totalVoteCount: (json['totalVoteCount'] as num).toInt(),
      commentCount: (json['commentCount'] as num).toInt(),
    );

Map<String, dynamic> _$TodayWorryToJson(TodayWorry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'option1Content': instance.option1Content,
      'option2Content': instance.option2Content,
      'option1Vote': instance.option1Vote,
      'option2Vote': instance.option2Vote,
      'description': instance.description,
      'category': instance.category,
      'voteResults': instance.voteResults,
      'totalVoteCount': instance.totalVoteCount,
      'commentCount': instance.commentCount,
    };
