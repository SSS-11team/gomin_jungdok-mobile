import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gomin_jungdok_mobile/common/const/colors.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/presentation/screens/todayWorryDetails_screen.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/provider/todayWorry_prov.dart';

class TodayWorryListScreens extends ConsumerStatefulWidget {
  const TodayWorryListScreens({super.key});

  @override
  _TodayWorryListScreensState createState() => _TodayWorryListScreensState();
}

class _TodayWorryListScreensState extends ConsumerState<TodayWorryListScreens> {
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: MAIN_BG_COLOR,
        body: Column(
          children: [
            // Countdown timer
            Container(
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
            Expanded(
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
                                builder: (context) => TodayWorryDetailsScreen(
                                    postId: post.postId),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                                        padding: const EdgeInsets.all(3.0),
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
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                              child: Text('1',
                                                  style:
                                                      TextStyle(fontSize: 20))),
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
                                                BorderRadius.circular(8),
                                          ),
                                          child: Center(
                                              child: Text(
                                            '2',
                                            style: TextStyle(fontSize: 20),
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
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    const Center(child: Text("데이터를 불러오지 못했습니다.")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<String> todayStringList = ['첫', '두', '세', '네', '다섯', '여섯', '일곱', '여덟'];
