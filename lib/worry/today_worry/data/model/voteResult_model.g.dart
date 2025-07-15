// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voteResult_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoteResults _$VoteResultsFromJson(Map<String, dynamic> json) => VoteResults(
      option: json['option'] as String,
      voteCount: (json['voteCount'] as num).toInt(),
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$VoteResultsToJson(VoteResults instance) =>
    <String, dynamic>{
      'option': instance.option,
      'voteCount': instance.voteCount,
      'percentage': instance.percentage,
    };
