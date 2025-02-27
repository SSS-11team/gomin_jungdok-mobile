import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gomin_jungdok_mobile/common/const/api.dart';
import 'package:gomin_jungdok_mobile/worry/worry_solution/presentation/widget/selectionButton_widget.dart';
import 'package:gomin_jungdok_mobile/worry/worry_solution/provider/solutionDetails_prov.dart';
import 'dart:async';

import 'dart:convert';
import 'package:http/http.dart' as http;

//여기까지
class Post {
  final int id;
  final String title;

  Post({required this.id, required this.title});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
    );
  }
}

class ApiService {
  Future<List<Post>> fetchPosts({int? size, int? lastId}) async {
    // ✅ 동적으로 쿼리 파라미터 생성
    final uri = Uri.parse('$BASE_URL/api/post').replace(queryParameters: {
      if (size != null) 'size': size.toString(),
      if (lastId != null) 'last-id': lastId.toString(),
    });

    try {
      final response = await http.get(uri);
      // 상태 코드 및 응답 본문 출력
      debugPrint('📡 상태 코드: ${response.statusCode}');
      debugPrint('📡 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        //  JSON 응답이 `Map<String, dynamic>` 형태인지 확인 후 `data` 필드 추출
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final posts = (jsonResponse['data']?['posts'] as List?)
            ?.map((post) => Post.fromJson(post))
            .toList();

        return posts ?? []; // null 대신 빈 리스트 반환
      } else {
        debugPrint('❌ 오류: 상태 코드 ${response.statusCode}');
        return []; // 오류 발생 시 빈 리스트 반환
      }
    } catch (e) {
      debugPrint('Error fetching posts: $e');
      return []; //  예외 발생 시 빈 리스트 반환
    }
  }

  // 선택지 투표
  Future<bool> vote(int postId, int choice) async {
    final url = Uri.parse('$BASE_URL/api/post/$postId/vote');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'vote': choice}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error voting: $e');
      return false;
    }
  }
}

final postProvider = FutureProvider<List<Post>>((ref) async {
  final apiService = ApiService();
  return await apiService.fetchPosts();
});

//  formatDuration 함수 적용
String formatDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);
  return "$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
}

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  late Timer _timer;
  Duration _remainingTime = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateRemainingTime();
    _startTimer();
  }

  void _calculateRemainingTime() {
    DateTime now = DateTime.now();
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    setState(() {
      _remainingTime = endOfDay.difference(now);
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateRemainingTime();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postAsync = ref.watch(postProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildTimerUI(), // ✅ UX 개선된 타이머 UI
            const SizedBox(height: 10),
            Expanded(
              child: postAsync.when(
                data: (posts) => _buildPostList(posts), // ✅ UX 개선된 게시글 리스트
                loading: () => _buildLoadingUI(),
                error: (error, stackTrace) => _buildErrorUI(error),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerUI() {
    return Column(
      children: [
        Container(
          width: 360,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 235, 206),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Text(
                "오늘의 고민 마감까지 남은 시간",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 5),
              Text(
                formatDuration(_remainingTime),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildPostList(List<Post> posts) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final solutionDetailsAsync = ref.watch(fetchDetailProvider(post.id));
        final info = solutionDetailsAsync.value;

        return InkWell(
          onTap: () => context.push('/details', extra: post.id),
          borderRadius: BorderRadius.circular(10),
          child: Card(
            elevation: 3,
            color: const Color.fromARGB(255, 251, 246, 243),
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (info != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: SelectionButton(
                            postId: post.id,
                            label: info.option1Content,
                            optionNum: 1,
                            voteCount: info.option1Vote,
                            votePercentage: "${info.option1Percentage}",
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: SelectionButton(
                            postId: post.id,
                            label: info.option2Content,
                            optionNum: 2,
                            voteCount: info.option2Vote,
                            votePercentage: "${info.option2Percentage}",
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingUI() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.redAccent,
      ),
    );
  }

  Widget _buildErrorUI(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.redAccent, size: 40),
          const SizedBox(height: 8),
          const Text(
            "오류가 발생했습니다. 다시 시도해주세요!",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(error.toString(), style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
