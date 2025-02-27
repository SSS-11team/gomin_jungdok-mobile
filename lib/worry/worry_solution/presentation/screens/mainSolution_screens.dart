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
      // ✅ 상태 코드 및 응답 본문 출력
      debugPrint('📡 상태 코드: ${response.statusCode}');
      debugPrint('📡 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
        // ✅ JSON 응답이 `Map<String, dynamic>` 형태인지 확인 후 `data` 필드 추출
        final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
        final posts = (jsonResponse['data']?['posts'] as List?)
            ?.map((post) => Post.fromJson(post))
            .toList();

        return posts ?? []; // ✅ null 대신 빈 리스트 반환
      } else {
        debugPrint('❌ 오류: 상태 코드 ${response.statusCode}');
        return []; // ✅ 오류 발생 시 빈 리스트 반환
      }
    } catch (e) {
      debugPrint('Error fetching posts: $e');
      return []; // ✅ 예외 발생 시 빈 리스트 반환
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

// ✅ formatDuration 함수 적용
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

  // ✅ 현재 시간과 자정까지 남은 시간을 계산
  void _calculateRemainingTime() {
    DateTime now = DateTime.now();
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    setState(() {
      _remainingTime = endOfDay.difference(now);
    });
  }

  // ✅ 1초마다 남은 시간 업데이트
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ 남은시간 카운트
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "오늘의 고민 공개 전까지",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    formatDuration(_remainingTime),
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFA743E),
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  )
                ],
              ),
            ),
            // ✅ 게시글 목록
            Expanded(
              child: Scrollbar(
                thumbVisibility: false, // 🔥 스크롤 시에만 스크롤바 보이게 설정
                child: postAsync.when(
                  data: (posts) => ListView.separated(
                    itemCount: posts.length,
                    separatorBuilder: (context, index) =>
                        const Divider(color: Colors.grey),
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      final solutionDetailsAsync =
                          ref.watch(fetchDetailProvider(post.id));
                      final info = solutionDetailsAsync.value;

                      return GestureDetector(
                        onTap: () {
                          context.push('/details', extra: post.id);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ✅ 게시글 제목
                              Padding(
                                padding: const EdgeInsets.only(left: 25.0),
                                child: Text(
                                  post.title,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),

                              // ✅ 선택지 버튼
                              if (info != null)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .start, // ✅ 선택지가 왼쪽 정렬되도록 수정
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: SizedBox(
                                        width: 177,
                                        child: SelectionButton(
                                          postId: post.id,
                                          label: info.option1Content,
                                          optionNum: 1,
                                          voteCount: info.option1Vote,
                                          votePercentage:
                                              "${info.option1Vote}%",
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10), // 버튼 간격 유지
                                    SizedBox(
                                      width: 177, // ✅ 동일한 크기 설정
                                      child: SelectionButton(
                                        postId: post.id,
                                        label: info.option2Content,
                                        optionNum: 2,
                                        voteCount: info.option2Vote,
                                        votePercentage: "${info.option2Vote}%",
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, stackTrace) =>
                      const Center(child: Text("오류 발생")),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
