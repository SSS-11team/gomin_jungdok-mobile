import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gomin_jungdok_mobile/common/presentation/screens/splash_screen.dart';
import 'package:gomin_jungdok_mobile/common/presentation/widgets/navigation_bar.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/presentation/screens/todayWorryList_screens.dart';
import 'package:gomin_jungdok_mobile/worry/past_worry/presentation/screens/pastWorry.dart';
import 'package:gomin_jungdok_mobile/worry/worry_regist/%08ai_worry/presentation/screens/ai_analyze.dart';
import 'package:gomin_jungdok_mobile/worry/worry_regist/%08ai_worry/presentation/screens/ai_worry.dart';
import 'package:gomin_jungdok_mobile/worry/worry_regist/normal_worry/presentation/screens/normal_worry.dart';
import 'package:gomin_jungdok_mobile/profile/presentation/screens/myProfile.dart';
import 'package:gomin_jungdok_mobile/worry/worry_solution/presentation/screens/mainSolution_screens.dart';
import 'package:gomin_jungdok_mobile/worry/worry_solution/presentation/screens/solutionDetails_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/splash', // 초기 경로를 스플래시로 설정
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: Navigation_bar(
            currentIndex: _getCurrentIndex(state.uri.toString()),
            onTabSelected: (index) => _onTabSelected(context, index),
          ),
        );
      },
      routes: [
        GoRoute(path: '/home', builder: (context, state) => MainView()),
        GoRoute(
          path: '/normalWorry',
          builder: (context, state) => NormalWorry(),
        ),
        GoRoute(
          path: '/aiWorry',
          builder: (context, state) => AiWorry(),
        ),
        // GoRoute(
        //   path: '/todayWorry',
        //   builder: (context, state) => TodayWorryTime(),
        // ),
        GoRoute(
          path: '/todayWorry',
          builder: (context, state) => TodayWorryListScreens(),
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
          path: '/aiWorryAnalyze',
          builder: (context, state) => AiAnalyze(),
        ),
        GoRoute(
          path: '/details',
          builder: (context, state) {
            final postId = state.extra as int;
            return SolutionDetailsView(postId: postId);
          },
        ),
      ],
    ),
  ],
);

int _getCurrentIndex(String location) {
  if (location == '/home') return 0;
  if (location == '/todayWorry') return 1;
  if (location == '/normalWorry' || location == '/aiWorry') return 2;
  if (location == '/pastWorry') return 3;
  if (location == '/myProfile') return 4;
  return 0;
}

void _onTabSelected(BuildContext context, int index) {
  if (index == 2) {
    (context as Element).markNeedsBuild();
    _showPopupMenu(context);
  } else {
    context.go(_getPathFromIndex(index));
  }
}

String _getPathFromIndex(int index) {
  switch (index) {
    case 0:
      return '/home';
    case 1:
      return '/todayWorry';
    case 3:
      return '/pastWorry';
    case 4:
      return '/myProfile';
    default:
      return '/home';
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
          child: Text('일반 고민 작성',
              style: TextStyle(fontSize: 16, color: Colors.black)),
        ),
      ),
      const PopupMenuDivider(),
      const PopupMenuItem<String>(
        value: 'ai',
        child: Center(
          child: Text('AI 고민 작성',
              style: TextStyle(fontSize: 16, color: Colors.black)),
        ),
      ),
    ],
  ).then((String? value) {
    if (value == 'general') {
      context.go('/normalWorry');
    } else if (value == 'ai') {
      context.go('/aiWorry');
    }
  });
}
