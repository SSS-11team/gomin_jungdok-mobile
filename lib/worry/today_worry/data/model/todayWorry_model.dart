import 'package:json_annotation/json_annotation.dart';

part 'todayWorry_model.g.dart';

@JsonSerializable()
class TodayWorry {
  final int postId;
  final String title;
  final String description;
  final int voteCount;

  TodayWorry({
    required this.postId,
    required this.title,
    required this.description,
    required this.voteCount,
  });
  factory TodayWorry.fromJson(Map<String, dynamic> json) =>
      _$TodayWorryFromJson(json);

  Map<String, dynamic> toJson() => _$TodayWorryToJson(this);
}
