
import 'package:json_annotation/json_annotation.dart';

part 'comment_model.g.dart';

@JsonSerializable()
class Comment {
  final int id;
  final String profileImage;
  final String nickname;
  final String description;
  final int parentCommentId;
  final String createdAt;
  final int hierarchy;
  final bool isMine;

  Comment({
    required this.id,
    required this.profileImage,
    required this.nickname,
    required this.description,
    required this.parentCommentId,
    required this.createdAt,
    required this.hierarchy,
    required this.isMine
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  Map<String, dynamic> toJson() => _$CommentToJson(this);
}