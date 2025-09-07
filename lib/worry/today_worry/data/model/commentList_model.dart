// comment_list_response.dart
import 'package:json_annotation/json_annotation.dart';
import 'comment_model.dart';

part 'commentList_model.g.dart';

@JsonSerializable()
class CommentListResponse {
  final List<Comment> comments;

  CommentListResponse({required this.comments});

  factory CommentListResponse.fromJson(Map<String, dynamic> json) =>
      _$CommentListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CommentListResponseToJson(this);
}
