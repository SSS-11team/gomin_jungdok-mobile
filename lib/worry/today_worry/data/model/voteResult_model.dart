import 'package:json_annotation/json_annotation.dart';

part 'voteResult_model.g.dart';

@JsonSerializable()
class VoteResults {
  final String option;
  final int voteCount;
  final double percentage;

  VoteResults({
    required this.option,
    required this.voteCount,
    required this.percentage,
  });

  factory VoteResults.fromJson(Map<String, dynamic> json) =>
      _$VoteResultsFromJson(json);

  Map<String, dynamic> toJson() => _$VoteResultsToJson(this);
}
