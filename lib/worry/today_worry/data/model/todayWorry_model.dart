import 'package:gomin_jungdok_mobile/worry/today_worry/data/model/voteResult_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todayWorry_model.g.dart';

@JsonSerializable()
class TodayWorry {
  final int postId;
  final String title;
  final String description;
  final String category;
  final VoteResults voteResults;
  final int totalVoteCount;
  final int commentCount;

  TodayWorry({
    required this.postId,
    required this.title,
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
