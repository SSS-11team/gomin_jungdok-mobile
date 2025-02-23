import 'package:json_annotation/json_annotation.dart';

part 'solutionVote_model.g.dart';

@JsonSerializable()
class SolutionVote {
  final String? option1Percentage;
  final String? option2Percentage;

  @JsonKey(defaultValue: 0)
  final int voteOfOption1;

  @JsonKey(defaultValue: 0)
  final int voteOfOption2;

  SolutionVote(
      {this.option1Percentage,
      this.option2Percentage,
      this.voteOfOption1 = 0,
      this.voteOfOption2 = 0});

  factory SolutionVote.fromJson(Map<String, dynamic> json) =>
      _$SolutionVoteFromJson(json);

  Map<String, dynamic> toJson() => _$SolutionVoteToJson(this);
}
