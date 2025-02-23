// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solutionVote_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolutionVote _$SolutionVoteFromJson(Map<String, dynamic> json) => SolutionVote(
      option1Percentage: json['option1Percentage'] as String?,
      option2Percentage: json['option2Percentage'] as String?,
    );

Map<String, dynamic> _$SolutionVoteToJson(SolutionVote instance) =>
    <String, dynamic>{
      'option1Percentage': instance.option1Percentage,
      'option2Percentage': instance.option2Percentage,
    };
