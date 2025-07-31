// repo provider

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gomin_jungdok_mobile/common/provider/common_prov.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/data/model/todayWorryDetails_model.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/data/model/todayWorry_model.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/data/repository/todayWorry_repository.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/data/service/todayWorry_service.dart';

final todayWorryRepoProvider = Provider<TodayWorryRepository>((ref) {
  final dio = ref.read(dioProvider);
  return TodayWorryRepository(dio);
});

//service provider
final todayWorryServiceProvider = Provider<TodayWorryService>((ref) {
  final repo = ref.read(todayWorryRepoProvider);
  return TodayWorryService(repo);
});

final fetchTodayWorryPostsProvider =
    FutureProvider<List<TodayWorry>>((ref) async {
  final service = ref.read(todayWorryServiceProvider);
  try {
    return service.fetchTodayWorryPosts();
  } catch (e) {
    debugPrint("[ERROR] fetchTodayWorryProvider: $e");
    rethrow;
  }
});

final fetchTodayWorryDetailsPostProvider =
    FutureProvider.family<TodayWorryDetails, int>((ref, postId) async {
  final service = ref.read(todayWorryServiceProvider);
  try {
    return service.fetchTodayWorryDetailsPost(postId);
  } catch (e) {
    debugPrint("[ERROR] fetchTodayWorryDetailProvider: $e");
    rethrow;
  }
});



final todayWorryPaginationProvider =
    StateNotifierProvider<TodayWorryPaginationNotifier, List<TodayWorry>>(
  (ref) => TodayWorryPaginationNotifier(ref),
);

class TodayWorryPaginationNotifier extends StateNotifier<List<TodayWorry>> {
  final Ref _ref;

  TodayWorryPaginationNotifier(this._ref) : super([]) {
    fetchMore(); // 최초 1회 데이터 요청
  }

  bool _isLoading = false;
  bool _hasMore = true;

  Future<void> fetchMore() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    final lastId = state.isNotEmpty ? state.last.id : null;

    try {
      final newItems = await _ref.read(todayWorryServiceProvider)
          .fetchTodayWorryPosts(size: 10, lastId: lastId); // ✅ ref.read 사용
      if (newItems.isEmpty) {
        _hasMore = false;
      } else {
        state = [...state, ...newItems];
      }
    } catch (e) {
      debugPrint('[ERROR] Pagination fetchMore: $e');
    } finally {
      _isLoading = false;
    }
  }
}

