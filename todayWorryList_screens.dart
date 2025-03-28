// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gomin_jungdok_mobile/common/const/colors.dart';
// import 'package:gomin_jungdok_mobile/worry/today_worry/presentation/screens/todayWorryDetails_screen.dart';
// import 'package:gomin_jungdok_mobile/worry/today_worry/provider/todayWorry_prov.dart';

// class TodayWorryListScreens extends ConsumerWidget {
//   const TodayWorryListScreens({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final todayWorryPosts = ref.watch(fetchTodayWorryPostsProvider);

//     return Scaffold(
//       backgroundColor: MAIN_BG_COLOR,
//       appBar: AppBar(
//         title: const Text('오늘의 고민 목록'),
//         backgroundColor: MAIN_BG_COLOR,
//       ),
//       body: todayWorryPosts.when(
//         data: (todayWorryList) {
//           return ListView.builder(
//             itemCount: todayWorryList.length,
//             itemBuilder: (context, index) {
//               final post = todayWorryList[index];
//               return ListTile(
//                 title: Text(post.title),
//                 subtitle: Text(post.description),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>
//                           TodayWorryDetailsScreen(postId: post.postId),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (error, stackTrace) => Center(child: Text('데이터를 불러오지 못했습니다.')),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gomin_jungdok_mobile/common/const/colors.dart';
import 'package:gomin_jungdok_mobile/common/presentation/router/go_router.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/presentation/screens/todayWorryDetails_screen.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/provider/todayWorry_prov.dart';

class TodayWorryListScreens extends ConsumerStatefulWidget {
  const TodayWorryListScreens({super.key});

  @override
  _TodayWorryListScreensState createState() => _TodayWorryListScreensState();
}

class _TodayWorryListScreensState extends ConsumerState<TodayWorryListScreens> {
  List<String> selectedCategories = [];
  List<String> categories = ["일상", "연애", "진로", "인간관계", "사회생활"];

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

  String formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return "$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final todayWorryPosts = ref.watch(fetchTodayWorryPostsProvider);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          centerTitle: true,
          title: Image.asset('assets/launcher_icon/logoTypo.png'),
          //고민중독 로고 넣기
        ),
        backgroundColor: MAIN_BG_COLOR,
        body: Column(
          children: [
            // 카테고리리
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  // 위에 카테고리 변수
                  bool isSelected = selectedCategories.contains(category);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: ChoiceChip(
                      label: Container(
                        width: 55,
                        alignment: Alignment.center, // 텍스트를 중앙 정렬
                        child: Text(category),
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (isSelected) {
                            selectedCategories.remove(category);
                          } else {
                            selectedCategories.add(category);
                          }
                        });
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  );
                }).toList(),
              ),
            ),

            // Countdown timer
            /* Container(
            color: Colors.white,
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text(
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
                const SizedBox(height: 25),
              ],
            ),
          ), */

            Expanded(

              //카테고리 추가
              child: ListView(
                children: worries //원래 저장 변수 찾기
                    .where((worry) =>
                        selectedCategories.contains(worry['category']))
                    .map(
                  (worry) {
                    return Card(
                      margin: EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5), // 카드 둥근 모서리 설정
                      ),
                      
                      
                      child: todayWorryPosts.when(
                        data: (todayWorryList) {
                          return Scrollbar(
                            thumbVisibility: false,
                            child: ListView.separated(
                              itemCount: todayWorryList.length,
                              separatorBuilder: (context, index) =>
                                  const Divider(color: Colors.grey),
                              itemBuilder: (context, index) {
                                final post = todayWorryList[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TodayWorryDetailsScreen(
                                                postId: post.postId),
                                      ),
                                    );
                                  },
                                  
                                  // 수정
                                  child: Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade200,
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            border: Border.all(
                                                color: Colors.grey, width: 0.5),
                                          ),
                                          child: Text(worry['category'],
                                              style: TextStyle(
                                                  color: Colors.grey)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                post.title,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 40,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                // color: const Color.fromARGB(
                                                //     255, 242, 213, 202),
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 255, 225, 213),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  '오늘의 고민 ${todayStringList[index]..toString()}번째',
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    color: MAIN_COLOR,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  height: 100,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Center(
                                                      child: Text('1',
                                                          style: TextStyle(
                                                              fontSize: 20))),
                                                ),
                                              ),
                                              const SizedBox(width: 10.0),
                                              Expanded(
                                                child: Container(
                                                  height: 100,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                    '2',
                                                    style:
                                                        TextStyle(fontSize: 20),
                                                  )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) =>
                            const Center(child: Text("데이터를 불러오지 못했습니다.")),
                      ),
                    );
                  },
                ),
              ),
            ),

            // 시간 하단 바
            Container(
              margin: EdgeInsets.all(25),
              padding: EdgeInsets.all(5),
              height: 40,
              width: 260,
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Text(
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
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ],
        ));
  }
}

List<String> todayStringList = ['첫', '두', '세', '네', '다섯', '여섯', '일곱', '여덟'];
