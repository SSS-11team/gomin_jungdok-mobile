import 'package:flutter/material.dart';

class TodayWorry extends StatelessWidget {
  const TodayWorry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '오늘의 고민 페이지',
          style: TextStyle(fontSize: 24, color: Colors.red),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
