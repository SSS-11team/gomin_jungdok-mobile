import 'package:json_annotation/json_annotation.dart';

part 'solutionVote_model.g.dart';

@JsonSerializable()
class SolutionVote {
  final String? option1Percentage;
  final String? option2Percentage;

  SolutionVote({
    this.option1Percentage,
    this.option2Percentage,
  });
  factory SolutionVote.fromJson(Map<String, dynamic> json) =>
      _$SolutionVoteFromJson(json);

  Map<String, dynamic> toJson() => _$SolutionVoteToJson(this);
}
