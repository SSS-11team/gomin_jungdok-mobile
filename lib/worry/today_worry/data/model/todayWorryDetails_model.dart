import 'package:gomin_jungdok_mobile/worry/today_worry/data/model/voteResult_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'todayWorryDetails_model.g.dart';

@JsonSerializable()
class TodayWorryDetails {
  @JsonKey(name: 'post_id')
  final int postId;

  @JsonKey(name: 'post_title')
  final String postTitle;

  @JsonKey(name: 'post_desc')
  final String postDesc;

  final List<String>? imageUrls;

  @JsonKey(name: 'voteResults')
  final List<VoteResults> voteResults;
  final int totalVoteCount;
  final int commentCount;

  TodayWorryDetails({
    required this.postId,
    required this.postTitle,
    required this.postDesc,
    this.imageUrls,
    required this.voteResults,
    required this.totalVoteCount,
    required this.commentCount
  });

  factory TodayWorryDetails.fromJson(Map<String, dynamic> json) =>
      _$TodayWorryDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$TodayWorryDetailsToJson(this);
}
