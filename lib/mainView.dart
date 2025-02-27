import 'package:flutter/material.dart';
import 'package:gomin_jungdok_mobile/navigation_bar.dart';
import 'package:gomin_jungdok_mobile/worry/pastWorry.dart';
import 'package:gomin_jungdok_mobile/worry/todayWorry.dart';
import 'package:gomin_jungdok_mobile/worryRegist/ai_worry.dart';
import 'package:gomin_jungdok_mobile/worryRegist/myProfile.dart';
import 'package:gomin_jungdok_mobile/worryRegist/normal_worry.dart';
import 'dart:async';

import 'dart:convert';
import 'package:http/http.dart' as http;

class Mainview extends StatefulWidget {
  const Mainview({super.key});

  @override
  _MainviewState createState() => _MainviewState();
}

class _MainviewState extends State<Mainview> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    HomeContent(), // 홈
    TodayWorry(), // 오늘의 고민
    Container(), // 고민등록하기
    PastWorry(), // 과거의 고민
    MyProfile(), // 마이페이지
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index; // 다른 탭 전환
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('앱 메인 화면'),
        backgroundColor: Colors.white,
      ),
      body: _tabs[_currentIndex], // 현재 선택된 콘텐츠 표시
      backgroundColor: Colors.white,
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  _HomeContentState createState() => _HomeContentState();
}

//여기까지
class Post {
  final int id;
  final String content;

  Post({required this.id, required this.content});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      content: json['content'] as String,
    );
  }
}

class ApiService {
  final String baseUrl = 'http://34.47.92.139:8080';

  // 고민 리스트 가져오기
  Future<List<Post>> fetchPosts(int size, int lastId) async {
    final url = Uri.parse('$baseUrl/api/post?size=$size&last-id=$lastId');
    
    try {
      final response = await http.get(url);

       // ✅ 상태 코드와 응답 본문 출력
      print('📡 상태 코드: ${response.statusCode}');
      print('📡 응답 본문: ${response.body}');
      
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((post) => Post.fromJson(post)).toList();
      } else {
        print('❌ 오류: 상태 코드 ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
    return [Post(id: 4, content: '고민 4 - 인터넷 연결 없음'),
        Post(id: 5, content: '고민 5 - 서버 다운'),];
  }

  // 선택지 투표
  Future<bool> vote(int postId, int choice) async {
    final url = Uri.parse('$baseUrl/api/vote/$postId');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'choice': choice}),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error voting: $e');
      return false;
    }
  }
}

class _HomeContentState extends State<HomeContent> {
  final ApiService apiService = ApiService();
  List<Post> posts = [];
  int lastId = 0;
  int size = 10;
  bool isLoading = false;
  bool hasMore = true;
  final ScrollController _scrollController = ScrollController();
  late Timer _timer;
  Duration _remainingTime = Duration(hours: 24);

  @override
  void initState() {
    super.initState();
    loadPosts();
    _scrollController.addListener(_scrollListener);
    _startTimer();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      loadPosts();
    }
  }

  void loadPosts() async {
    if (isLoading || !hasMore) return;
    setState(() => isLoading = true);

    List<Post> newPosts = await apiService.fetchPosts(size, lastId);
    setState(() {
      if (newPosts.isNotEmpty) {
        posts.addAll(newPosts);
        lastId = newPosts.last.id;
      } else {
        hasMore = false;
      }
      isLoading = false;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime = _remainingTime - Duration(seconds: 1);
        } else {
          _remainingTime = Duration(hours: 24);
        }
      });
    });
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
  }

  Map<int, String?> selectedOptions = {};

  void showVoteDialog(int postId, int choice) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[300],
          title: Text(
            "선택 확인",
            style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
          ),
          content: Text(
            "이 선택을 하시겠습니까?\n투표 후에는 변경할 수 없습니다.",
            style: TextStyle(color: Colors.grey),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '취소',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                bool success = await apiService.vote(postId, choice);
                if (success) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("투표 완료!")));
                } else {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("투표 실패")));
                }
              },
              child: Text(
                '확인',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 250,
          height: 30,
          padding: EdgeInsets.all(0),
          color: Colors.grey[300],
          child: Column(
            children: [
              SizedBox(height: 5),
              Text(_formatTime(_remainingTime),
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Text('남은시간 카운트', style: TextStyle(fontSize: 9, color: Colors.black54)),
        Expanded(
          child: ListView.separated(
            itemCount: posts.length + 1,
            separatorBuilder: (context, index) => Divider(color: Colors.grey),
            itemBuilder: (context, index) {
              if (index < posts.length) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 25.0),
                        child: Text(posts[index].content,
                            style:
                                TextStyle(fontSize: 18, color: Colors.black87)),
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 10, top: 10),
                              child: ElevatedButton(
                                onPressed: () =>
                                    showVoteDialog(posts[index].id, 1),
                                child: Text('선택지1'),
                                style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(150, 62),
                                    minimumSize: Size(150, 62),
                                    backgroundColor: Colors.grey[300],
                                    foregroundColor: Colors.black,
                                    shape: BeveledRectangleBorder()),
                              ),
                            ),
                          ),
                          SizedBox(width: 46),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 0, right: 25, top: 10),
                              child: ElevatedButton(
                                onPressed: () =>
                                    showVoteDialog(posts[index].id, 2),
                                child: Text('선택지2'),
                                style: ElevatedButton.styleFrom(
                                    fixedSize: const Size(150, 62),
                                    minimumSize: Size(150, 62),
                                    backgroundColor: Colors.grey[300],
                                    foregroundColor: Colors.black,
                                    shape: BeveledRectangleBorder()),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return hasMore
                    ? Padding(
                        padding: EdgeInsets.all(10),
                        child: Center(child: CircularProgressIndicator()))
                    : SizedBox();
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer.cancel();
    super.dispose();
  }
}
