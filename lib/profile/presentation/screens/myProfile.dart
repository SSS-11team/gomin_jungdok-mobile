import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
        body: Column(
          children: [
            Divider(
              thickness: 1,
              color: Colors.grey, // 검은색 라인
              indent: 10,
              endIndent: 10,
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 150,
              height: 150,
              child: Image.asset('assets/launcher_icon/logoTypo.png'),
            ),
            SizedBox(height: 40),
            Expanded(
              child: ListView(
                children: [
                  _buildTextButton(context, Icons.notifications, '알림 설정', '/'),
                  _buildTextButton(context, Icons.assignment, '공지사항', '/'),
                  _buildTextButton(
                      context, Icons.person_outline, '개인정보 수집 및 이용', '/'),
                  _buildTextButton(context, Icons.lock, '비밀번호 변경', '/'),
                  _buildTextButton(context, Icons.update, '버전 정보', '/'),
                  _buildTextButton(context, Icons.exit_to_app, '로그아웃', '/'),
                  _buildTextButton(context, Icons.delete_forever, '탈퇴하기', '/'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextButton(
      BuildContext context, IconData icon, String title, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 13.0),
      child: GestureDetector(
        onTap: () {
          context.go(route); // 전달받은 라우트로 이동
        },
        child: Row(
          children: [
            Icon(icon, color: Color.fromARGB(255, 252, 133, 86)), // 🔥 아이콘 추가
            const SizedBox(width: 10), // 🔥 아이콘과 텍스트 간격 조정
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
