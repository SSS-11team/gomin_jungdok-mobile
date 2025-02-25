import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gomin_jungdok_mobile/worry/pastWorry.dart';
import 'package:gomin_jungdok_mobile/worry/todayWorry.dart';
import 'package:gomin_jungdok_mobile/worryRegist/ai_analyze.dart';
import 'package:gomin_jungdok_mobile/worryRegist/ai_worry.dart';
import 'package:gomin_jungdok_mobile/worryRegist/mainView.dart';
import 'package:gomin_jungdok_mobile/worryRegist/myProfile.dart';
import 'package:gomin_jungdok_mobile/worryRegist/normal_worry.dart';
import 'package:gomin_jungdok_mobile/navigation_bar.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: Navigation_bar(
            currentIndex:
                _getCurrentIndex(state.uri.toString()), // state.location 사용
            onTabSelected: (index) => _onTabSelected(context, index),
          ),
        );
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Mainview(),
        ),
        GoRoute(
          path: '/normalWorry',
          builder: (context, state) => NormalWorry(),
        ),
        GoRoute(
          path: '/aiWorry',
          builder: (context, state) => AiWorry(),
        ),
        GoRoute(
          path: '/todayWorry',
          builder: (context, state) => TodayWorry(),
        ),
        GoRoute(
          path: '/pastWorry',
          builder: (context, state) => PastWorry(),
        ),
        GoRoute(
          path: '/myProfile',
          builder: (context, state) => MyProfile(),
        ),
        GoRoute(
          path: '/aiWorry_analyze',
          builder: (context, state) {
            final selectedImage = state.extra as File?; // 🛠 null 가능성 고려

            if (selectedImage == null) {
              // 🔥 예외 처리: 선택된 이미지가 없으면 이전 화면으로 이동
              return const AiWorry();
            }

            return AiAnalyze(selectedImage: selectedImage);
          },
        ),
      ],
    ),
  ],
);

int _getCurrentIndex(String location) {
  if (location == '/') return 0;
  if (location == '/todayWorry') return 1;
  if (location == '/normalWorry' || location == '/aiWorry')
    return 2; // 고민등록하기 경로 추가
  if (location == '/pastWorry') return 3;
  if (location == '/myProfile') return 4;
  return 0; // 기본값은 홈
}

void _onTabSelected(BuildContext context, int index) {
  if (index == 2) {
    // 고민등록하기 버튼 클릭 시 인덱스를 2로 설정하여 색상 변경
    (context as Element).markNeedsBuild(); // 위젯 리빌드 강제 (필요 시)
    _showPopupMenu(context);
  } else {
    context.go(_getPathFromIndex(index)); // 다른 탭은 라우트로 이동
  }
}

String _getPathFromIndex(int index) {
  switch (index) {
    case 0:
      return '/';
    case 1:
      return '/todayWorry';
    case 3:
      return '/pastWorry';
    case 4:
      return '/myProfile';
    default:
      return '/';
  }
}

void _showPopupMenu(BuildContext context) async {
  final RenderBox overlay =
      Overlay.of(context).context.findRenderObject() as RenderBox;

  await showMenu<String>(
    context: context,
    position: RelativeRect.fromLTRB(
      overlay.size.width / 2 - 86,
      overlay.size.height - 220,
      overlay.size.width / 2 + 86,
      0,
    ),
    elevation: 8.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    color: Colors.white,
    items: [
      const PopupMenuItem<String>(
        value: 'general',
        child: Center(
          child: Text(
            '일반 고민 작성',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
      const PopupMenuDivider(),
      const PopupMenuItem<String>(
        value: 'ai',
        child: Center(
          child: Text(
            'AI 고민 작성',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
      ),
    ],
  ).then((String? value) {
    if (value == 'general') {
      context.go('/normalWorry'); // 고민등록하기 페이지로 이동
    } else if (value == 'ai') {
      context.go('/aiWorry'); // AI 고민 작성 페이지로 이동
    }
  });
}
