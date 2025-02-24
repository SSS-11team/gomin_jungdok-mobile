import 'package:dio/dio.dart';
import 'package:gomin_jungdok_mobile/worry_solution/data/model/solutionDetails_model.dart';
import 'package:gomin_jungdok_mobile/worry_solution/data/repository/solutionDetails_repository.dart';
import 'package:gomin_jungdok_mobile/worry_solution/data/service/solutionDetailsService.dart';
import 'package:riverpod/riverpod.dart';

// Dio (API 호출을 위해 필요한 프로바이더)
final dioProvider = Provider<Dio>((ref) {
  return Dio();
});

// repo provider
final detailRepoProvider = Provider<SolutionDetailsRepository>((ref) {
  final dio = ref.read(dioProvider);
  return SolutionDetailsRepository(dio);
});

//service provider
final detailServiceProvider = Provider<SolutionDetailsService>((ref) {
  final repo = ref.read(detailRepoProvider);
  return SolutionDetailsService(repo);
});

// SolutionDetals Provider (게시글 정보 가져오는 프로바이더)
final fetchDetailProvider =
    FutureProvider.family<SolutionDetails, int>((ref, postId) async {
  final service = ref.read(detailServiceProvider);
  return service.fetchSolutionDetails(postId);
});

enum LoadingState { error, loading, sucess, fail }
