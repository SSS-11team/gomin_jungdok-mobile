import 'package:json_annotation/json_annotation.dart';

part 'voteResult_model.g.dart';

@JsonSerializable()
class VoteResult {
  final String option;
  final double? percentage;

  VoteResult({
    required this.option,
    required this.percentage,
  });

  factory VoteResult.fromJson(Map<String, dynamic> json) =>
      _$VoteResultFromJson(json);

  Map<String, dynamic> toJson() => _$VoteResultToJson(this);
}
