import 'package:flutter/material.dart';
import 'package:gomin_jungdok_mobile/navigation_bar.dart';
import 'package:gomin_jungdok_mobile/worry/pastWorry.dart';
import 'package:gomin_jungdok_mobile/worry/todayWorry.dart';
import 'package:gomin_jungdok_mobile/worryRegist/myProfile.dart';
import 'package:gomin_jungdok_mobile/worryRegist/worryRegist.dart';

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
    WorryRegist(), // 고민 등록하기
    PastWorry(), // 과거의 고민
    MyProfile(), // 마이 프로필
  ];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('앱 메인 화면'),
      ),
      body: _tabs[_currentIndex], // 현재 선택된 콘텐츠 표시
      bottomNavigationBar: Navigation_bar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('홈 화면 콘텐츠', style: TextStyle(fontSize: 24)),
    );
  }
}
