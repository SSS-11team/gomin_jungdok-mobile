import 'package:json_annotation/json_annotation.dart';

part 'commentRegister_model.g.dart';

@JsonSerializable()
class CommentRequest {
  final String description;
  final int? parentCommentId;

  CommentRequest({
    required this.description,
    this.parentCommentId,
  });

  factory CommentRequest.fromJson(Map<String, dynamic> json) =>
      _$CommentRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CommentRequestToJson(this);
}
