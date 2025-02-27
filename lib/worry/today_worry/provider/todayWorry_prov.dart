// repo provider
import 'dart:math';

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
    FutureProvider.family<TodayWorry, int>((ref, postId) async {
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
