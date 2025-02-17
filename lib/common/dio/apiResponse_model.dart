import 'package:json_annotation/json_annotation.dart';

part 'apiResponse_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final int statusCode;
  final String message;
  final T data;

  ApiResponse(
      {required this.statusCode, required this.message, required this.data});

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}
