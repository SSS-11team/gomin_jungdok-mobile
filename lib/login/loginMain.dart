import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gomin_jungdok_mobile/login/appleLogin.dart';
import 'package:gomin_jungdok_mobile/login/googleLogin.dart';
import 'package:gomin_jungdok_mobile/login/kakaoLogin.dart';

class LoginMainScreen extends StatefulWidget {
  const LoginMainScreen({super.key});

  @override
  _LoginMainScreenState createState() => _LoginMainScreenState();
}

class _LoginMainScreenState extends State<LoginMainScreen> {
  String? userNickname; // 사용자 닉네임
  final KakaoAuthService _kakaoAuthService = KakaoAuthService();
  final GoogleAuthService _googleAuthService = GoogleAuthService();
  final AppleAuthService _appleAuthService = AppleAuthService();

  Future<void> _handleKakaoLogin() async {
    try {
      String? nickname = await _kakaoAuthService.loginWithKakao();

      if (nickname != null && mounted) {
        setState(() {
          userNickname = nickname;
        });
        print("✅ 로그인 성공: $nickname");

        context.go('/home'); // ✅ 로그인 성공한 경우에만 홈으로 이동
      } else {
        print("❌ 로그인 실패: 사용자 정보 없음");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("카카오 로그인 실패")),
          );
        }
      }
    } catch (error) {
      print("❌ 로그인 중 오류 발생: $error");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("카카오 로그인 중 오류가 발생했습니다.")),
        );
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    try {
      String? googleNickname = await _googleAuthService.signInWithGoogle();
      if (googleNickname != null && mounted) {
        setState(() {
          userNickname = googleNickname;
        });
        print("✅ 구글 로그인 성공: $googleNickname");
        context.go('/home');
      } else {
        print("❌ 구글 로그인 실패: 사용자 정보 없음");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("구글 로그인 실패")),
          );
        }
      }
    } catch (error) {
      print("❌ 애플 로그인 중 오류 발생: $error");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("구글 로그인 도중 오류가 발생했습니다.")),
        );
      }
    }
  }

  Future<void> _handleAppleLogin() async {
    try {
      String? appleNickname = await _appleAuthService.signInWithApple();
      if (appleNickname != null && mounted) {
        setState(() {
          userNickname = appleNickname;
        });
        print("✅ 애플 로그인 성공: $appleNickname");
        context.go('/home');
      } else {
        print("❌ 애플 로그인 실패: 사용자 정보 없음");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("애플 로그인 실패")),
          );
        }
      }
    } catch (error) {
      print("❌ 애플 로그인 중 오류 발생: $error");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("애플 로그인 도중 오류가 발생했습니다.")),
        );
      }
    }
  }

  /// 🔹 로그아웃 처리
  Future<void> _handleLogout() async {
    await _kakaoAuthService.logout();
    setState(() {
      userNickname = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 300,
            ),
            // 로고
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/icons/로고+타이포.png"),
                      fit: BoxFit.cover //이미지가 appbar를 채울 수 있도록 설정
                      )),
            ),
            const SizedBox(height: 250),

            // 🔹 카카오 로그인 버튼
            GestureDetector(
              onTap: _handleKakaoLogin,
              child: Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE500), // 카카오톡 노란색
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "카카오로 간편 로그인",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 🔹 구글 로그인 버튼
            GestureDetector(
              onTap: _handleGoogleLogin,
              child: Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: const Center(
                  child: Text(
                    "Google로 간편 로그인",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 🔹 애플 로그인 버튼
            GestureDetector(
              onTap: () {
                _handleAppleLogin();
              },
              child: Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    "Apple로 간편 로그인",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
