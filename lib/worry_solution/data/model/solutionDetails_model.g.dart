// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solutionDetails_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolutionDetails _$SolutionDetailsFromJson(Map<String, dynamic> json) =>
    SolutionDetails(
      isvoted: json['isvoted'] as bool,
      isMine: json['isMine'] as bool,
      isScrap: json['isScrap'] as bool,
      isAi: json['isAi'] as bool,
      title: json['title'] as String,
      description: json['description'] as String,
      images:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
      option1Content: json['option1Content'] as String,
      option2Content: json['option2Content'] as String,
      option1Percentage: json['option1Percentage'] as String?,
      option2Percentage: json['option2Percentage'] as String?,
    );

Map<String, dynamic> _$SolutionDetailsToJson(SolutionDetails instance) =>
    <String, dynamic>{
      'isvoted': instance.isvoted,
      'isMine': instance.isMine,
      'isScrap': instance.isScrap,
      'isAi': instance.isAi,
      'title': instance.title,
      'description': instance.description,
      'images': instance.images,
      'option1Content': instance.option1Content,
      'option2Content': instance.option2Content,
      'option1Percentage': instance.option1Percentage,
      'option2Percentage': instance.option2Percentage,
    };
