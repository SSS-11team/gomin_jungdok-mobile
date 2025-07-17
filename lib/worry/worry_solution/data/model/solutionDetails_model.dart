
import 'package:json_annotation/json_annotation.dart';

part 'solutionDetails_model.g.dart';

@JsonSerializable()
class SolutionDetails {
  final bool isVoted;
  final bool isMine;
  final bool isAi;
  final String? profileImage;
  final String writerNickname;
  final String createdAt;
  final String title;
  final String description;
  final Map<String, dynamic>? images;
  final String option1Content;
  final String option2Content;
  final int option1Vote;
  final int option2Vote;
  final String? option1Percentage;
  final String? option2Percentage;
  final String? category;

  SolutionDetails(
      {required this.isVoted,
      required this.isMine,
      required this.isAi,
      this.profileImage,
      required this.writerNickname,
      required this.createdAt,
      required this.title,
      required this.description,
      this.images,
      required this.option1Content,
      required this.option2Content,
      required this.option1Vote,
      required this.option2Vote,
      this.option1Percentage,
      this.option2Percentage,
      this.category,
      });

  factory SolutionDetails.fromJson(Map<String, dynamic> json) =>
      _$SolutionDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$SolutionDetailsToJson(this);
}
