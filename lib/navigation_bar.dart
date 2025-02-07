import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lucide_icons/lucide_icons.dart';

class Navigation_bar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const Navigation_bar({
    required this.currentIndex,
    required this.onTabSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      iconSize: 20.0,
      unselectedFontSize: 12.0,
      selectedFontSize: 12.0,
      currentIndex: currentIndex,
      selectedItemColor: Color(0xFFFA743E),
      unselectedItemColor: Colors.grey,
      onTap: onTabSelected,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 4),
              Icon(Icons.home),
              SizedBox(height: 5), // 아이콘과 라벨 사이 간격 조정
            ],
          ),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 4),
              Icon(FontAwesomeIcons.fire),
              SizedBox(height: 5), // 아이콘과 라벨 사이 간격 조정
            ],
          ),
          label: '오늘의고민',
        ),
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 4),
              Icon((Icons.add)),
              SizedBox(height: 5), // 아이콘과 라벨 사이 간격 조정
            ],
          ),
          label: '고민등록하기',
        ),
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 4),
              Icon((LucideIcons.bookOpen)),
              SizedBox(height: 5), // 아이콘과 라벨 사이 간격 조정
            ],
          ),
          label: '과거의고민',
        ),
        BottomNavigationBarItem(
          icon: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 4),
              Icon(Icons.person),
              SizedBox(height: 5), // 아이콘과 라벨 사이 간격 조정
            ],
          ),
          label: '마이페이지',
        ),
      ],
    );
  }
}
