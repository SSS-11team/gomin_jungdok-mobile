// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'solutionDetails_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SolutionDetails _$SolutionDetailsFromJson(Map<String, dynamic> json) =>
    SolutionDetails(
      isVoted: json['isVoted'] as bool,
      isMine: json['isMine'] as bool,
      isAi: json['isAi'] as bool,
      profileImage: json['profileImage'] as String?,
      writerNickname: json['writerNickname'] as String,
      createdAt: json['createdAt'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      images: json['images'] as Map<String, dynamic>?,
      option1Content: json['option1Content'] as String,
      option2Content: json['option2Content'] as String,
      option1Vote: (json['option1Vote'] as num).toInt(),
      option2Vote: (json['option2Vote'] as num).toInt(),
      option1Percentage: json['option1Percentage'] as String?,
      option2Percentage: json['option2Percentage'] as String?,
    );

Map<String, dynamic> _$SolutionDetailsToJson(SolutionDetails instance) =>
    <String, dynamic>{
      'isVoted': instance.isVoted,
      'isMine': instance.isMine,
      'isAi': instance.isAi,
      'profileImage': instance.profileImage,
      'writerNickname': instance.writerNickname,
      'createdAt': instance.createdAt,
      'title': instance.title,
      'description': instance.description,
      'images': instance.images,
      'option1Content': instance.option1Content,
      'option2Content': instance.option2Content,
      'option1Vote': instance.option1Vote,
      'option2Vote': instance.option2Vote,
      'option1Percentage': instance.option1Percentage,
      'option2Percentage': instance.option2Percentage,
    };
