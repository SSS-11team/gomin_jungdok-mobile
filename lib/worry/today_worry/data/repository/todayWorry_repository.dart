import 'package:dio/dio.dart';
import 'package:gomin_jungdok_mobile/common/const/api.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/data/model/todayWorryDetails_model.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/data/model/todayWorry_model.dart';

import 'package:retrofit/retrofit.dart';

part 'todayWorry_repository.g.dart';

@RestApi(baseUrl: "http://34.63.52.253:3030/api/post/today")
abstract class TodayWorryRepository {
  factory TodayWorryRepository(Dio dio, {String baseUrl}) =
      _TodayWorryRepository;

  @GET('')
Future<List<TodayWorry>> fetchTodayWorryPosts({
  @Query('size') int size = 10,       // 기본값 10
  @Query('last-id') int? lastId,      // 마지막 게시글 id
});


  @GET('/{post_id}')
  Future<TodayWorryDetails> fetchTodayWorryDetailsPosts({
    @Path('post_id') required int id,
  });
}
