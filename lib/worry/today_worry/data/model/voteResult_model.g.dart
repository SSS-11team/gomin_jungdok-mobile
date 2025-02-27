// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voteResult_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoteResult _$VoteResultFromJson(Map<String, dynamic> json) => VoteResult(
      option: json['option'] as String,
      percentage: (json['percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$VoteResultToJson(VoteResult instance) =>
    <String, dynamic>{
      'option': instance.option,
      'percentage': instance.percentage,
    };
