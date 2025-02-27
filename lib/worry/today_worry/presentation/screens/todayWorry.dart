import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TodayWorry extends StatefulWidget {
  const TodayWorry({super.key});

  @override
  State<TodayWorry> createState() => _TodayWorry();
}

class _TodayWorry extends State<TodayWorry> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Divider(
              color: Colors.grey,
              thickness: 1,
              height: 1,
            ),
            SizedBox(
              height: 260,
            ),
            Text(
              "오늘의 고민 공개 전까지",
              style: TextStyle(fontSize: 25),
            ),
            Text(
              formatDuration(_remainingTime),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFA743E),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                context.go('/myProfile');
              },
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey, // 밑줄 색상
                      width: 1, // 밑줄 두께 조정
                    ),
                  ),
                ),
                child: const Text(
                  "알림 설정 바로가기",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey, // 글자 색상
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

String formatDuration(Duration duration) {
  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);
  return "$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
}
