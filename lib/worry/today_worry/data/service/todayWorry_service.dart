import 'package:gomin_jungdok_mobile/worry/today_worry/data/model/todayWorryDetails_model.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/data/model/todayWorry_model.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/data/repository/todayWorry_repository.dart';

class TodayworryService {
  final TodayWorryRepository repository;

  TodayworryService(this.repository);

  Future<TodayWorry> fetchTodayWorryPosts() async {
    final response = await repository.fetchTodayWorryPosts();

    return response;
  }

  Future<TodayWorryDetails> fetchTodayWorryDetailsPost(int postId) async {
    final response = await repository.fetchTodayWorryDetailsPosts(id: postId);
    return response;
  }
}
