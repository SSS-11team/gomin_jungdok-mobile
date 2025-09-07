import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:dio/dio.dart';
import 'package:gomin_jungdok_mobile/common/const/api.dart';

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
              context.go('/home');
            },
          ),
        ),
        body: Column(
          children: [
            const Divider(
                thickness: 1, color: Colors.grey, indent: 10, endIndent: 10),
            const SizedBox(height: 20),
            SizedBox(
              width: 150,
              height: 150,
              child: Image.asset(
                  'assets/icons/\ub85c\uace0+\ud0c0\uc774\ud3ec.png'),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: ListView(
                children: [
                  _buildTextButton(context, Icons.notifications, '알림 설정', () {
                    context.go('/home');
                  }),
                  _buildTextButton(context, Icons.assignment, '공지사항', () {
                    context.go('/home');
                  }),
                  _buildTextButton(
                      context, Icons.person_outline, '개인정보 수집 및 이용', () {
                    context.go('/home');
                  }),
                  _buildTextButton(context, Icons.lock, '비밀번호 변경', () {
                    context.go('/home');
                  }),
                  _buildTextButton(context, Icons.update, '버전 정보', () {
                    context.go('/home');
                  }),
                  _buildTextButton(context, Icons.exit_to_app, '로그아웃',
                      () async {
                    final storage = FlutterSecureStorage();
                    final provider =
                        await storage.read(key: 'login_provider') ?? '';
                    await _logoutUser(provider);
                    context.go('/login');
                  }),
                  _buildTextButton(context, Icons.delete_forever, '탈퇴하기',
                      () async {
                    final confirmed = await _showWithdrawDialog(
                        context); // ✅ await로 팝업 닫힌 후 결과 받기

                    if (confirmed == true) {
                      await withdrawUser(); // 탈퇴 로직 실행

                      /// ❗ context.go()는 팝업 닫힌 다음 안전하게 실행되어야 함
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        context.go('/login');
                      });
                    }
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextButton(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 13.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: const Color.fromARGB(255, 252, 133, 86)),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(fontSize: 22, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}

// 🔹 로그아웃
Future<void> _logoutUser(String provider) async {
  final storage = FlutterSecureStorage();

  try {
    if (provider == 'kakao') {
      try {
        await UserApi.instance.accessTokenInfo(); // 토큰 유효성 확인
        await UserApi.instance.logout();
        print("✅ Kakao 로그아웃 완료");
      } catch (e) {
        print("ℹ️ 카카오 토큰 없음 또는 만료됨");
      }
    }

    if (provider == 'apple' || provider == 'google') {
      await FirebaseAuth.instance.signOut();
      print("✅ Firebase 로그아웃 완료");
    }

    await storage.deleteAll(); // secure storage 비우기
    print("🧼 모든 세션 종료 완료");
  } catch (e) {
    print("❌ 로그아웃 중 에러: $e");
  }
}

// 🔹 탈퇴
Future<void> withdrawUser() async {
  final storage = FlutterSecureStorage();

  try {
    final accessToken = await storage.read(key: 'accessToken');

    if (accessToken == null) {
      print("❌ 저장된 accessToken이 없습니다.");
      return;
    }

    final dioInstance = dio.Dio();
    final response = await dioInstance.delete(
      "$BASE_URL/api/auth/delete",
      options: dio.Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      ),
    );

    if (response.statusCode == 200) {
      print("✅ 탈퇴 완료");
      await storage.deleteAll();
    } else {
      print("❌ 탈퇴 실패: ${response.statusCode} ${response.data}");
    }
  } catch (e) {
    print("❌ 탈퇴 중 에러: $e");
  }
}

Future<bool?> _showWithdrawDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text("정말 탈퇴하시겠어요?"),
      content: const Text("탈퇴 시 계정 정보가 삭제됩니다."),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(
              dialogContext, false), // ✅ 여기 context 아니라 dialogContext
          child: const Text("취소"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text("탈퇴"),
        ),
      ],
    ),
  );
}
