import 'package:dio/dio.dart';
import 'package:gomin_jungdok_mobile/common/const/api.dart';
import 'package:gomin_jungdok_mobile/common/dio/apiResponse_model.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/data/model/commentList_model.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/data/model/commentRegister_model.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/data/model/comment_model.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/data/model/todayWorryDetails_model.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/data/model/todayWorry_model.dart';

import 'package:retrofit/retrofit.dart';

part 'todayWorry_repository.g.dart';

@RestApi(baseUrl: "$BASE_URL/api/post/today")
abstract class TodayWorryRepository {
  factory TodayWorryRepository(Dio dio, {String baseUrl}) =
      _TodayWorryRepository;

  @GET('')
  Future<List<TodayWorry>> fetchTodayWorryPosts();

  @GET('/{post_id}')
  Future<TodayWorryDetails> fetchTodayWorryDetailsPosts({
    @Path('post_id') required int id,
  });

  @GET('/{id}/comment')
  Future<ApiResponse<CommentListResponse>> fetchComment({
    @Path('id') required int id,
  });

  @POST('/{id}/comment')
  Future<ApiResponse> registerComment({
    @Path('id') required int id,
    @Body() required CommentRequest body,
  });
}
