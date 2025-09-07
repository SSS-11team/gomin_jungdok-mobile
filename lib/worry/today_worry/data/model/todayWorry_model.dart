import 'package:gomin_jungdok_mobile/worry/today_worry/data/model/voteResult_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todayWorry_model.g.dart';

@JsonSerializable()
class TodayWorry {
  final int id;
  final String title;
  final String option1Content;
  final String option2Content;
  final int option1Vote;
  final int option2Vote;
  final String description;
  final String category;
  final VoteResults voteResults;
  final int totalVoteCount;
  final int commentCount;

  TodayWorry({
    required this.id,
    required this.title,
    required this.option1Content,
    required this.option2Content,
    required this.option1Vote,
    required this.option2Vote,
    required this.description,
    required this.category,
    required this.voteResults,
    required this.totalVoteCount,
    required this.commentCount
  });
  factory TodayWorry.fromJson(Map<String, dynamic> json) =>
      _$TodayWorryFromJson(json);

  Map<String, dynamic> toJson() => _$TodayWorryToJson(this);
}
