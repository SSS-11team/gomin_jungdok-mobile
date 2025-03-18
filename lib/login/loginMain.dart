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

  /// 🔹 카카오 로그인 처리
  // Future<void> _handleKakaoLogin() async {
  //   String? nickname = await _kakaoAuthService.loginWithKakao();
  //   if (nickname != null) {
  //     setState(() {
  //       userNickname = nickname;
  //     });

  //     // ✅ 로그인 성공 시 '/home' 화면으로 이동
  //     if (mounted) {
  //       context.go('/home');
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("카카오 로그인 실패")),
  //     );
  //   }
  // }
  // -> 현재 이 코드는 서버가 켜져있지 않은 상황에서 로그인이 실패하면
  // ui를 확인할 수 없는 메인 코드이기 때문에 주석처리했음
  // 아래 코드는 카카오 로그인을 실패하더라도 무조건 넘어가도록 구현
  Future<void> _handleKakaoLogin() async {
    try {
      String? nickname = await _kakaoAuthService.loginWithKakao();
      if (nickname != null) {
        setState(() {
          userNickname = nickname;
        });

        print("✅ 로그인 성공: $nickname");
      } else {
        print("❌ 로그인 실패: 사용자 정보 없음");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("카카오 로그인 실패")),
        );
      }
    } catch (error) {
      print("❌ 로그인 중 오류 발생: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("로그인 중 오류가 발생했습니다.")),
      );
    } finally {
      // ✅ 로그인 성공 여부와 관계없이 '/home'으로 이동
      if (mounted) {
        context.go('/home');
      }
    }
  }

  Future<void> _handleGoogleLogin() async {
    try {
      String? googleNickname = await _googleAuthService.signInWithGoogle();
      if (googleNickname != null) {
        setState(() {
          userNickname = googleNickname;
        });
        print("✅ 구글 로그인 성공: $googleNickname");
      } else {
        print("❌ 구글 로그인 실패: 사용자 정보 없음");
      }
    } catch (error) {
      print("❌ 구글 로그인 중 오류 발생: $error");
    } finally {
      // ✅ 로그인 성공 여부와 관계없이 '/home'으로 이동
      if (mounted) {
        context.go('/home');
      }
    }
  }

  Future<void> _handleAppleLogin() async {
    try {
      String? appleNickname = await _appleAuthService.signInWithApple();
      if (appleNickname != null) {
        setState(() {
          userNickname = appleNickname;
        });
        print("✅ 애플 로그인 성공: $appleNickname");
      } else {
        print("❌ 애플 로그인 실패: 사용자 정보 없음");
      }
    } catch (error) {
      print("❌ 애플 로그인 중 오류 발생: $error");
    } finally {
      // ✅ 로그인 성공 여부와 관계없이 '/home'으로 이동
      if (mounted) {
        context.go('/home');
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

            // 🔹 로그아웃 버튼 (나중에 마이페이지에서 활용할 수 있도록)
            // ElevatedButton(
            //   onPressed: _handleLogout,
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.red,
            //     padding:
            //         const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            //   ),
            //   child: const Text(
            //     "로그아웃",
            //     style: TextStyle(color: Colors.white, fontSize: 16),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
