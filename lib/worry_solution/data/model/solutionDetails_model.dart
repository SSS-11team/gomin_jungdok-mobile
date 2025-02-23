import 'package:json_annotation/json_annotation.dart';

part 'solutionDetails_model.g.dart';

@JsonSerializable()
class SolutionDetails {
  final bool isvoted;
  final bool isMine;
  final bool isScrap;
  final bool isAi;
  final String title;
  final String description;
  // 일단 String으로 구현했는데 이미지라 추가적인 상의 필요
  final List<String>? images;
  final String option1Content;
  final String option2Content;
  final String? option1Percentage;
  final String? option2Percentage;

  SolutionDetails(
      {required this.isvoted,
      required this.isMine,
      required this.isScrap,
      required this.isAi,
      required this.title,
      required this.description,
      this.images,
      required this.option1Content,
      required this.option2Content,
      this.option1Percentage,
      this.option2Percentage});

  factory SolutionDetails.fromJson(Map<String, dynamic> json) =>
      _$SolutionDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$SolutionDetailsToJson(this);
}
