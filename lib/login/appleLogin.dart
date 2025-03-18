import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleAuthService {
  Future<String?> signInWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      // ✅ 애플 로그인 성공 시 닉네임 설정 (이름 정보가 없으면 '애플 사용자' 기본값)
      String nickname = credential.givenName ?? "애플 사용자";
      print("✅ 애플 로그인 성공: $nickname");

      return nickname;
    } catch (error) {
      print("❌ 애플 로그인 실패: $error");
      return null;
    }
  }
}
