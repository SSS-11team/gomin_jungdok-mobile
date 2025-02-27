import 'package:gomin_jungdok_mobile/worry/today_worry/data/model/todayWorryDetails_model.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/data/model/todayWorry_model.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/data/repository/todayWorry_repository.dart';

class TodayWorryService {
  final TodayWorryRepository repository;

  TodayWorryService(this.repository);

  Future<List<TodayWorry>> fetchTodayWorryPosts() async {
    return await repository.fetchTodayWorryPosts();
  }

  Future<TodayWorryDetails> fetchTodayWorryDetailsPost(int postId) async {
    return await repository.fetchTodayWorryDetailsPosts(id: postId);
  }
}
