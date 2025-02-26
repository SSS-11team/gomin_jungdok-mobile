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
      backgroundColor: Colors.white,
      iconSize: 20.0,
      unselectedFontSize: 12.0,
      selectedFontSize: 12.0,
      currentIndex: currentIndex,
      selectedItemColor: Color(0xFFFA743E),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        onTabSelected(index);
      },
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '홈',
        ),
        BottomNavigationBarItem(
          icon: Icon(FontAwesomeIcons.fire),
          label: '오늘의고민',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: '고민등록하기',
        ),
        BottomNavigationBarItem(
          icon: Icon(LucideIcons.bookOpen),
          label: '과거의고민',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '마이페이지',
        ),
      ],
    );
  }
}
