// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solutionVote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolutionVote _$SolutionVoteFromJson(Map<String, dynamic> json) => SolutionVote(
      option1Percentage: (json['option1Percentage'] as num?)?.toDouble() ?? 0.0,
      option2Percentage: (json['option2Percentage'] as num?)?.toDouble() ?? 0.0,
      voteOfOption1: (json['voteOfOption1'] as num?)?.toInt() ?? 0,
      voteOfOption2: (json['voteOfOption2'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SolutionVoteToJson(SolutionVote instance) =>
    <String, dynamic>{
      'option1Percentage': instance.option1Percentage,
      'option2Percentage': instance.option2Percentage,
      'voteOfOption1': instance.voteOfOption1,
      'voteOfOption2': instance.voteOfOption2,
    };
