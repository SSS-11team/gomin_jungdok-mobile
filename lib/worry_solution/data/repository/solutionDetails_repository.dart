import 'package:dio/dio.dart';
import 'package:gomin_jungdok_mobile/common/dio/apiResponse_model.dart';
import 'package:gomin_jungdok_mobile/common/dio/const.dart';
import 'package:gomin_jungdok_mobile/worry_solution/data/model/solutionDetails_model.dart';
import 'package:gomin_jungdok_mobile/worry_solution/data/model/solutionVote_model.dart';

import 'package:retrofit/retrofit.dart';

part 'solutionDetails_repository.g.dart';

@RestApi(baseUrl: "$BASE_URI/api/post")
abstract class SolutionDetailsRepository {
  factory SolutionDetailsRepository(Dio dio, {String baseUrl}) =
      _SolutionDetailsRepository;

  @GET('/{id}')
  Future<ApiResponse<SolutionDetails>> fetchDetailsSolutionPosts({
    @Path('id') required int id,
  });

  @POST('/{id}/vote')
  Future<ApiResponse<SolutionVote>> solutionVote(
      {@Path('id') required int id,
      @Body() required Map<String, dynamic> vote});
}
