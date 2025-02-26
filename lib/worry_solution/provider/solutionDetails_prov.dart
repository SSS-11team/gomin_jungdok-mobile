import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gomin_jungdok_mobile/common/provider/common_prov.dart';
import 'package:gomin_jungdok_mobile/worry_solution/data/model/solutionDetails_model.dart';
import 'package:gomin_jungdok_mobile/worry_solution/data/repository/solutionDetails_repository.dart';
import 'package:gomin_jungdok_mobile/worry_solution/data/service/solutionDetailsService.dart';

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
  try {
    return service.fetchSolutionDetails(postId);
  } catch (e) {
    debugPrint("[ERROR] fetchDetailProvider: $e");
    rethrow;
  }
});

enum LoadingState { error, loading, success, fail }
