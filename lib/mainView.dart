import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gomin_jungdok_mobile/common/const/api.dart';
import 'package:gomin_jungdok_mobile/worry/worry_solution/presentation/widget/selectionButton_widget.dart';
import 'dart:async';

import 'dart:convert';
import 'package:http/http.dart' as http;

// // //여기까지
// // class Post {
// //   final int id;
// //   final String title;

// //   Post({required this.id, required this.title});

// //   factory Post.fromJson(Map<String, dynamic> json) {
// //     return Post(
// //       id: json['id'] as int,
// //       title: json['title'] as String,
// //     );
// //   }
// // }

// // class ApiService {
// //   Future<List<Post>?> fetchPosts(int? size, int? lastId) async {
// //     // ✅ 동적으로 쿼리 파라미터 생성
// //     final uri = Uri.parse('$BASE_URL/api/post').replace(queryParameters: {
// //       if (size != null) 'size': size.toString(),
// //       if (lastId != null) 'last-id': lastId.toString(),
// //     });
// //     try {
// //       final response = await http.get(uri);

// //       // ✅ 상태 코드 및 응답 본문 출력
// //       debugPrint('📡 상태 코드: ${response.statusCode}');
// //       debugPrint('📡 응답 본문: ${response.body}');

// //       if (response.statusCode == 200) {
// //         // ✅ JSON 응답이 `Map<String, dynamic>` 형태인지 확인 후 `data` 필드 추출
// //         final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
// //         final posts = (jsonResponse['data']?['posts'] as List?)
// //             ?.map((post) => Post.fromJson(post))
// //             .toList();

// //         if (posts == null) {
// //           debugPrint('⚠️ "data.posts" 필드가 없거나 형식이 맞지 않음');
// //         }

// //         return posts;
// //       } else {
// //         debugPrint('❌ 오류: 상태 코드 ${response.statusCode}');
// //         return null;
// //       }
// //     } catch (e) {
// //       debugPrint('Error fetching posts: $e');
// //     }
// //     return [
// //       Post(id: 4, title: '고민 4 - 인터넷 연결 없음'),
// //       Post(id: 5, title: '고민 5 - 서버 다운'),
// //     ];
// //   }

// //   // 선택지 투표
// //   Future<bool> vote(int postId, int choice) async {
// //     final url = Uri.parse('$BASE_URL/api/post/$postId/vote');

// //     try {
// //       final response = await http.post(
// //         url,
// //         headers: {"Content-Type": "application/json"},
// //         body: jsonEncode({'vote': choice}),
// //       );

// //       return response.statusCode == 200;
// //     } catch (e) {
// //       print('Error voting: $e');
// //       return false;
// //     }
// //   }
// // }

// // class _HomeContentState extends State<HomeContent> {
// //   final ApiService apiService = ApiService();
// //   List<Post> posts = [];
// //   int? lastId;
// //   int? size;
// //   bool isLoading = false;
// //   bool hasMore = true;
// //   final ScrollController _scrollController = ScrollController();
// //   late Timer _timer;
// //   Duration _remainingTime = Duration(hours: 24);

// //   @override
// //   void initState() {
// //     super.initState();
// //     loadPosts();
// //     _scrollController.addListener(_scrollListener);
// //     _startTimer();
// //   }

// //   void _scrollListener() {
// //     if (_scrollController.position.pixels >=
// //         _scrollController.position.maxScrollExtent - 100) {
// //       loadPosts();
// //     }
// //   }

// //   // void loadPosts() async {
// //   //   if (isLoading || !hasMore) return;
// //   //   setState(() => isLoading = true);

// //   //   List<Post> newPosts = await apiService.fetchPosts(size, lastId);
// //   //   setState(() {
// //   //     if (newPosts.isNotEmpty) {
// //   //       posts.addAll(newPosts);
// //   //       lastId = newPosts.last.id;
// //   //     } else {
// //   //       hasMore = false;
// //   //     }
// //   //     isLoading = false;
// //   //   });
// //   // }
// //   void loadPosts() async {
// //     if (isLoading || !hasMore) return;

// //     setState(() => isLoading = true);

// //     List<Post>? newPosts = await apiService.fetchPosts(size, lastId);

// //     setState(() {
// //       if (newPosts != null && newPosts.isNotEmpty) {
// //         posts.addAll(newPosts);
// //         lastId = newPosts.last.id;
// //         hasMore = false;
// //         debugPrint("📡 hasMore 상태: $hasMore");
// //       } else if (newPosts == null) {
// //         debugPrint("⚠️ 게시물을 불러오는 중 오류 발생");
// //       } else {
// //         hasMore = false;
// //       }
// //       isLoading = false;
// //     });
// //   }

// //   void _startTimer() {
// //     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
// //       setState(() {
// //         if (_remainingTime.inSeconds > 0) {
// //           _remainingTime = _remainingTime - Duration(seconds: 1);
// //         } else {
// //           _remainingTime = Duration(hours: 24);
// //         }
// //       });
// //     });
// //   }

// //   String _formatTime(Duration duration) {
// //     String twoDigits(int n) => n.toString().padLeft(2, '0');
// //     return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
// //   }

// //   Map<int, String?> selectedOptions = {};

// //   // void showVoteDialog(int postId, int choice) {
// //   //   showDialog(
// //   //     context: context,
// //   //     builder: (context) {
// //   //       return AlertDialog(
// //   //         backgroundColor: Colors.grey[300],
// //   //         title: Text(
// //   //           "선택 확인",
// //   //           style: const TextStyle(
// //   //               color: Colors.grey,
// //   //               fontWeight: FontWeight.bold,
// //   //               fontSize: 20.0),
// //   //         ),
// //   //         content: Text(
// //   //           "이 선택을 하시겠습니까?\n투표 후에는 변경할 수 없습니다.",
// //   //           style: TextStyle(color: Colors.grey),
// //   //         ),
// //   //         actions: <Widget>[
// //   //           TextButton(
// //   //             onPressed: () => Navigator.of(context).pop(),
// //   //             child: Text(
// //   //               '취소',
// //   //               style: TextStyle(color: Colors.black),
// //   //             ),
// //   //           ),
// //   //           TextButton(
// //   //             onPressed: () async {
// //   //               Navigator.of(context).pop();
// //   //               bool success = await apiService.vote(postId, choice);
// //   //               if (success) {
// //   //                 ScaffoldMessenger.of(context)
// //   //                     .showSnackBar(SnackBar(content: Text("투표 완료!")));
// //   //               } else {
// //   //                 ScaffoldMessenger.of(context)
// //   //                     .showSnackBar(SnackBar(content: Text("투표 실패")));
// //   //               }
// //   //             },
// //   //             child: Text(
// //   //               '확인',
// //   //               style: TextStyle(color: Colors.black),
// //   //             ),
// //   //           ),
// //   //         ],
// //   //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
// //   //       );
// //   //     },
// //   //   );
// //   // }
// // // ✅ 선택한 선택지의 postId를 기준으로 투표 상태를 저장하는 Map

// //   void showVoteDialog(int postId, int choice) {
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           backgroundColor: Colors.grey[300],
// //           title: Text(
// //             "선택 확인",
// //             style: const TextStyle(
// //                 color: Colors.grey,
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: 20.0),
// //           ),
// //           content: Text(
// //             "이 선택을 하시겠습니까?\n투표 후에는 변경할 수 없습니다.",
// //             style: TextStyle(color: Colors.grey),
// //           ),
// //           actions: <Widget>[
// //             TextButton(
// //               onPressed: () => Navigator.of(context).pop(),
// //               child: Text(
// //                 '취소',
// //                 style: TextStyle(color: Colors.black),
// //               ),
// //             ),
// //             TextButton(
// //               onPressed: () async {
// //                 Navigator.of(context).pop();

// //                 // ✅ 선택한 선택지를 Map에 저장하여 UI 갱신
// //                 setState(() {
// //                   selectedOptions[postId] = choice.toString(); // 선택한 옵션 저장
// //                 });

// //                 bool success = await apiService.vote(postId, choice);
// //                 if (success) {
// //                   ScaffoldMessenger.of(context)
// //                       .showSnackBar(SnackBar(content: Text("투표 완료!")));
// //                 } else {
// //                   ScaffoldMessenger.of(context)
// //                       .showSnackBar(SnackBar(content: Text("투표 실패")));
// //                 }
// //               },
// //               child: Text(
// //                 '확인',
// //                 style: TextStyle(color: Colors.black),
// //               ),
// //             ),
// //           ],
// //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return SafeArea(
// //       child: Scaffold(
// //         body: Column(
// //           children: [
// //             Container(
// //               width: 250,
// //               height: 30,
// //               padding: EdgeInsets.all(0),
// //               color: Colors.grey[300],
// //               child: Column(
// //                 children: [
// //                   SizedBox(height: 5),
// //                   Text(_formatTime(_remainingTime),
// //                       style:
// //                           TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
// //                 ],
// //               ),
// //             ),
// //             Text('남은시간 카운트',
// //                 style: TextStyle(fontSize: 9, color: Colors.black54)),
// //             Expanded(
// //               child: ListView.separated(
// //                 itemCount: posts.length + 1,
// //                 separatorBuilder: (context, index) =>
// //                     Divider(color: Colors.grey),
// //                 itemBuilder: (context, index) {
// //                   if (index < posts.length) {
// //                     return Padding(
// //                       padding: EdgeInsets.symmetric(vertical: 12.0),
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Padding(
// //                             padding: EdgeInsets.only(left: 25.0),
// //                             child: Text(posts[index].title,
// //                                 style: TextStyle(
// //                                     fontSize: 18, color: Colors.black87)),
// //                           ),
// //                           SizedBox(height: 8.0),
// //                           Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                             children: [
// //                               Expanded(
// //                                 child: Padding(
// //                                   padding: const EdgeInsets.only(
// //                                       left: 25, right: 10, top: 10),
// //                                   child: ElevatedButton(
// //                                     onPressed: () =>
// //                                         showVoteDialog(posts[index].id, 1),
// //                                     style: ElevatedButton.styleFrom(
// //                                         fixedSize: const Size(150, 62),
// //                                         minimumSize: Size(150, 62),
// //                                         backgroundColor: Colors.grey[300],
// //                                         foregroundColor: Colors.black,
// //                                         shape: BeveledRectangleBorder()),
// //                                     child: Text('선택지1'),
// //                                   ),
// //                                 ),
// //                               ),
// //                               SizedBox(width: 46),
// //                               Expanded(
// //                                 child: Padding(
// //                                   padding: const EdgeInsets.only(
// //                                       left: 0, right: 25, top: 10),
// //                                   child: ElevatedButton(
// //                                     onPressed: () =>
// //                                         showVoteDialog(posts[index].id, 2),
// //                                     style: ElevatedButton.styleFrom(
// //                                         fixedSize: const Size(150, 62),
// //                                         minimumSize: Size(150, 62),
// //                                         backgroundColor: Colors.grey[300],
// //                                         foregroundColor: Colors.black,
// //                                         shape: BeveledRectangleBorder()),
// //                                     child: Text('선택지2'),
// //                                   ),
// //                                 ),
// //                               ),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                     );
// //                   } else {
// //                     return hasMore
// //                         ? Material(
// //                             child: Padding(
// //                                 padding: EdgeInsets.all(10),
// //                                 child:
// //                                     Center(child: CircularProgressIndicator())),
// //                           )
// //                         : SizedBox();
// //                   }
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   @override
// //   void dispose() {
// //     _scrollController.dispose();
// //     _timer.cancel();
// //     super.dispose();
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:gomin_jungdok_mobile/common/const/api.dart';
// import 'dart:async';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class HomeContent extends StatefulWidget {
//   const HomeContent({super.key});

//   @override
//   _HomeContentState createState() => _HomeContentState();
// }

// // ✅ 게시글 모델
// class Post {
//   final int id;
//   final String title;

//   Post({required this.id, required this.title});

//   factory Post.fromJson(Map<String, dynamic> json) {
//     return Post(
//       id: json['id'] as int,
//       title: json['title'] as String,
//     );
//   }
// }

// // ✅ API 서비스
// class ApiService {
//   Future<List<Post>?> fetchPosts(int? size, int? lastId) async {
//     final uri = Uri.parse('$BASE_URL/api/post').replace(queryParameters: {
//       if (size != null) 'size': size.toString(),
//       if (lastId != null) 'last-id': lastId.toString(),
//     });

//     try {
//       final response = await http.get(uri);
//       debugPrint('📡 상태 코드: ${response.statusCode}');
//       debugPrint('📡 응답 본문: ${response.body}');

//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
//         final posts = (jsonResponse['data']?['posts'] as List?)
//             ?.map((post) => Post.fromJson(post))
//             .toList();

//         return posts;
//       } else {
//         debugPrint('❌ 오류: 상태 코드 ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       debugPrint('Error fetching posts: $e');
//     }
//     return [];
//   }

//   // ✅ 투표 API
//   Future<bool> vote(int postId, int choice) async {
//     final url = Uri.parse('$BASE_URL/api/post/$postId/vote');

//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({'vote': choice}),
//       );

//       return response.statusCode == 200;
//     } catch (e) {
//       print('Error voting: $e');
//       return false;
//     }
//   }
// }

// class _HomeContentState extends State<HomeContent> {
//   final ApiService apiService = ApiService();
//   List<Post> posts = [];
//   Map<int, int> selectedOptions = {}; // ✅ 선택한 옵션 저장 (postId -> 선택지 번호)
//   int? lastId;
//   bool isLoading = false;
//   bool hasMore = true;
//   final ScrollController _scrollController = ScrollController();
//   late Timer _timer;
//   Duration _remainingTime = Duration(hours: 24);

//   @override
//   void initState() {
//     super.initState();
//     loadPosts();
//     _scrollController.addListener(_scrollListener);
//     _startTimer();
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 100) {
//       loadPosts();
//     }
//   }

//   void loadPosts() async {
//     if (isLoading || !hasMore) return;
//     setState(() => isLoading = true);

//     List<Post>? newPosts = await apiService.fetchPosts(10, lastId);

//     setState(() {
//       if (newPosts != null && newPosts.isNotEmpty) {
//         posts.addAll(newPosts);
//         lastId = newPosts.last.id;
//         hasMore = false;
//       } else {
//         hasMore = false;
//       }
//       isLoading = false;
//     });
//   }

//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_remainingTime.inSeconds > 0) {
//           _remainingTime = _remainingTime - Duration(seconds: 1);
//         } else {
//           _remainingTime = Duration(hours: 24);
//         }
//       });
//     });
//   }

//   String _formatTime(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     return "${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes.remainder(60))}:${twoDigits(duration.inSeconds.remainder(60))}";
//   }

//   // ✅ 투표 다이얼로그
//   void showVoteDialog(int postId, int choice) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.grey[300],
//           title: Text(
//             "선택 확인",
//             style: const TextStyle(
//                 color: Colors.grey,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20.0),
//           ),
//           content: Text(
//             "이 선택을 하시겠습니까?\n투표 후에는 변경할 수 없습니다.",
//             style: TextStyle(color: Colors.grey),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('취소', style: TextStyle(color: Colors.black)),
//             ),
//             TextButton(
//               onPressed: () async {
//                 Navigator.of(context).pop();

//                 // ✅ 선택한 선택지를 Map에 저장하여 UI 갱신
//                 setState(() {
//                   selectedOptions[postId] = choice;
//                 });

//                 bool success = await apiService.vote(postId, choice);
//                 if (success) {
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(SnackBar(content: Text("투표 완료!")));
//                 } else {
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(SnackBar(content: Text("투표 실패")));
//                 }
//               },
//               child: Text('확인', style: TextStyle(color: Colors.black)),
//             ),
//           ],
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           children: [
//             Container(
//               width: 250,
//               height: 30,
//               color: Colors.grey[300],
//               child: Center(
//                 child: Text(_formatTime(_remainingTime),
//                     style:
//                         TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
//               ),
//             ),
//             Text('남은시간 카운트',
//                 style: TextStyle(fontSize: 9, color: Colors.black54)),
//             Expanded(
//               child: ListView.separated(
//                 itemCount: posts.length + 1,
//                 separatorBuilder: (context, index) =>
//                     Divider(color: Colors.grey),
//                 itemBuilder: (context, index) {
//                   if (index < posts.length) {
//                     final post = posts[index];
//                     final selected = selectedOptions[post.id];

//                     return Padding(
//                       padding: EdgeInsets.symmetric(vertical: 12.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(left: 25.0),
//                             child: Text(post.title,
//                                 style: TextStyle(
//                                     fontSize: 18, color: Colors.black87)),
//                           ),
//                           SizedBox(height: 8.0),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               ElevatedButton(
//                                 onPressed: selected == null
//                                     ? () => showVoteDialog(post.id, 1)
//                                     : null,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: selected == 1
//                                       ? Colors.red // 선택한 버튼만 빨간색
//                                       : Colors.grey[300], // 나머지는 회색
//                                 ),
//                                 child: Text('선택지1'),
//                               ),
//                               ElevatedButton(
//                                 onPressed: selected == null
//                                     ? () => showVoteDialog(post.id, 2)
//                                     : null,
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: selected == 2
//                                       ? Colors.red // 선택한 버튼만 빨간색
//                                       : Colors.grey[300], // 나머지는 회색
//                                 ),
//                                 child: Text('선택지2'),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     );
//                   } else {
//                     return hasMore
//                         ? Center(child: CircularProgressIndicator())
//                         : SizedBox();
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:gomin_jungdok_mobile/common/const/api.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// class HomeContent extends StatefulWidget {
//   const HomeContent({super.key});

//   @override
//   _HomeContentState createState() => _HomeContentState();
// }

// //여기까지
// class Post {
//   final int id;
//   final String title;

//   Post({required this.id, required this.title});

//   factory Post.fromJson(Map<String, dynamic> json) {
//     return Post(
//       id: json['id'] as int,
//       title: json['title'] as String,
//     );
//   }
// }

// // ✅ API 서비스
// class ApiService {
//   Future<List<Post>?> fetchPosts(int? size, int? lastId) async {
//     final uri = Uri.parse('$BASE_URL/api/post').replace(queryParameters: {
//       if (size != null) 'size': size.toString(),
//       if (lastId != null) 'last-id': lastId.toString(),
//     });

//     try {
//       final response = await http.get(uri);
//       debugPrint('📡 상태 코드: ${response.statusCode}');
//       debugPrint('📡 응답 본문: ${response.body}');

//       if (response.statusCode == 200) {
//         final jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));
//         final posts = (jsonResponse['data']?['posts'] as List?)
//             ?.map((post) => Post.fromJson(post))
//             .toList();

//         return posts;
//       } else {
//         debugPrint('❌ 오류: 상태 코드 ${response.statusCode}');
//         return null;
//       }
//     } catch (e) {
//       debugPrint('Error fetching posts: $e');
//     }
//     return [];
//   }

//   // ✅ 투표 API
//   Future<bool> vote(int postId, int choice) async {
//     final url = Uri.parse('$BASE_URL/api/post/$postId/vote');

//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode({'vote': choice}),
//       );

//       return response.statusCode == 200;
//     } catch (e) {
//       print('Error voting: $e');
//       return false;
//     }
//   }
// }

// class _HomeContentState extends State<HomeContent> {
//   final ApiService apiService = ApiService();
//   List<Post> posts = [];
//   Map<int, int> selectedOptions = {}; // ✅ 선택한 옵션 저장 (postId -> 선택지 번호)
//   int? lastId;
//   bool isLoading = false;
//   bool hasMore = true;
//   final ScrollController _scrollController = ScrollController();
//   late Timer _timer;
//   Duration _remainingTime = Duration.zero;

//   @override
//   void initState() {
//     super.initState();
//     loadPosts();
//     _scrollController.addListener(_scrollListener);
//     _calculateRemainingTime();
//     _startTimer();
//   }

//   void _scrollListener() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 100) {
//       loadPosts();
//     }
//   }

//   void loadPosts() async {
//     if (isLoading || !hasMore) return;
//     setState(() => isLoading = true);

//     List<Post>? newPosts = await apiService.fetchPosts(10, lastId);

//     setState(() {
//       if (newPosts != null && newPosts.isNotEmpty) {
//         posts.addAll(newPosts);
//         lastId = newPosts.last.id;
//         hasMore = false;
//       } else {
//         hasMore = false;
//       }
//       isLoading = false;
//     });
//   }

//   // ✅ 현재 시간과 자정까지 남은 시간을 계산하는 함수
//   void _calculateRemainingTime() {
//     DateTime now = DateTime.now();
//     DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
//     setState(() {
//       _remainingTime = endOfDay.difference(now);
//     });
//   }

//   // ✅ 1초마다 남은 시간 업데이트
//   void _startTimer() {
//     _timer = Timer.periodic(Duration(seconds: 1), (timer) {
//       setState(() {
//         if (_remainingTime.inSeconds > 0) {
//           _remainingTime = _remainingTime - Duration(seconds: 1);
//         } else {
//           _remainingTime = Duration(hours: 24); // 하루가 끝나면 24시간으로 리셋
//         }
//       });
//     });
//   }

//   // ✅ 남은 시간을 `hh:mm:ss` 형식으로 변환
//   String formatDuration(Duration duration) {
//     int hours = duration.inHours;
//     int minutes = duration.inMinutes.remainder(60);
//     int seconds = duration.inSeconds.remainder(60);
//     return "$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
//   }

//   // ✅ 투표 다이얼로그
//   void showVoteDialog(int postId, int choice) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           backgroundColor: Colors.grey[300],
//           title: Text(
//             "선택 확인",
//             style: const TextStyle(
//                 color: Colors.grey,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20.0),
//           ),
//           content: Text(
//             "이 선택을 하시겠습니까?\n투표 후에는 변경할 수 없습니다.",
//             style: TextStyle(color: Colors.grey),
//           ),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () => Navigator.of(context).pop(),
//               child: Text('취소', style: TextStyle(color: Colors.black)),
//             ),
//             TextButton(
//               onPressed: () async {
//                 Navigator.of(context).pop();

//                 setState(() {
//                   selectedOptions[postId] = choice;
//                 });

//                 bool success = await apiService.vote(postId, choice);
//                 if (success) {
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(SnackBar(content: Text("투표 완료!")));
//                 } else {
//                   ScaffoldMessenger.of(context)
//                       .showSnackBar(SnackBar(content: Text("투표 실패")));
//                 }
//               },
//               child: Text('확인', style: TextStyle(color: Colors.black)),
//             ),
//           ],
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           children: [
//             Container(
//               width: 250,
//               height: 30,
//               color: Colors.grey[300],
//               child: Center(
//                 child: Text(
//                   formatDuration(_remainingTime), // ✅ 카운트다운 표시
//                   style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             Text('남은시간 카운트',
//                 style: TextStyle(fontSize: 9, color: Colors.black54)),
//             Expanded(
//               child: ListView.separated(
//                 itemCount: posts.length + 1,
//                 separatorBuilder: (context, index) =>
//                     Divider(color: Colors.grey),
//                 itemBuilder: (context, index) {
//                   if (index < posts.length) {
//                     final post = posts[index];
//                     final selected = selectedOptions[post.id];

//                     return GestureDetector(
//                       onTap: () {
//                         context.push('/details', extra: post.id);
//                       },
//                       child: Padding(
//                         padding: EdgeInsets.symmetric(vertical: 12.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.only(left: 25.0),
//                               child: Text(
//                                 post.title,
//                                 style: TextStyle(
//                                     fontSize: 18, color: Colors.black87),
//                               ),
//                             ),
//                             SizedBox(height: 8.0),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                               children: [
//                                 ElevatedButton(
//                                   onPressed: selected == null
//                                       ? () => showVoteDialog(post.id, 1)
//                                       : null,
//                                   style: ElevatedButton.styleFrom(
//                                     fixedSize: const Size(150, 62),
//                                     minimumSize: const Size(150, 62),
//                                     backgroundColor: selected == 1
//                                         ? Colors.red
//                                         : Colors.grey[300],
//                                     foregroundColor: Colors.black,
//                                     shape: BeveledRectangleBorder(),
//                                   ),
//                                   child: Text('선택지1'),
//                                 ),
//                                 ElevatedButton(
//                                   onPressed: selected == null
//                                       ? () => showVoteDialog(post.id, 2)
//                                       : null,
//                                   style: ElevatedButton.styleFrom(
//                                     fixedSize: const Size(150, 62),
//                                     minimumSize: const Size(150, 62),
//                                     backgroundColor: selected == 2
//                                         ? Colors.red
//                                         : Colors.grey[300],
//                                     foregroundColor: Colors.black,
//                                     shape: BeveledRectangleBorder(),
//                                   ),
//                                   child: Text('선택지2'),
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   } else {
//                     return hasMore
//                         ? Center(child: CircularProgressIndicator())
//                         : SizedBox();
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

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
    final uri = Uri.parse('$BASE_URL/api/post').replace(queryParameters: {
      if (size != null) 'size': size.toString(),
      if (lastId != null) 'last-id': lastId.toString(),
    });

    try {
      final response = await http.get(uri);
      debugPrint('📡 상태 코드: ${response.statusCode}');
      debugPrint('📡 응답 본문: ${response.body}');

      if (response.statusCode == 200) {
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

  // ✅ 투표 API
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

// ✅ MainView (게시글 목록)
class MainView extends ConsumerWidget {
  const MainView({super.key});

  // ✅ 남은 시간 계산
  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return "$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postAsync = ref.watch(postProvider);
    Duration remainingTime = Duration(hours: 24); // 기본 24시간 남음

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            // ✅ 남은시간 카운트
            Container(
              width: 250,
              height: 30,
              color: Colors.grey[300],
              child: Center(
                child: Text(
                  formatDuration(remainingTime),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const Text('남은시간 카운트',
                style: TextStyle(fontSize: 9, color: Colors.black54)),

            // ✅ 게시글 목록
            Expanded(
              child: postAsync.when(
                data: (posts) => ListView.separated(
                  itemCount: posts.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.grey),
                  itemBuilder: (context, index) {
                    final post = posts[index];

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
                                    fontSize: 18, color: Colors.black87),
                              ),
                            ),
                            const SizedBox(height: 8.0),

                            // ✅ 선택지 버튼
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: SelectionButton(
                                    postId: post.id,
                                    label: '선택지1',
                                    optionNum: 1,
                                    voteCount: 0,
                                    votePercentage: "0%",
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: SelectionButton(
                                    postId: post.id,
                                    label: '선택지2',
                                    optionNum: 2,
                                    voteCount: 0,
                                    votePercentage: "0%",
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
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    const Center(child: Text("오류 발생")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
