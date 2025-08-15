import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    as secure_storage;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gomin_jungdok_mobile/common/const/api.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class AuthService {
  final Dio _dio = Dio();
  final secure_storage.FlutterSecureStorage _secureStorage =
      const secure_storage.FlutterSecureStorage();

  Future<void> logout() async {
    try {
      final accessToken = await _secureStorage.read(key: 'accessToken');

      if (accessToken != null) {
        // 1. 백엔드에 로그아웃 요청
        final response = await _dio.post(
          "$BASE_URL/api/auth/logout",
          options: Options(
            headers: {
              "Authorization": "Bearer $accessToken",
            },
          ),
        );

        print("📡 로그아웃 요청 결과: ${response.data}");
      } else {
        print("⚠️ 저장된 accessToken이 없습니다. 백엔드 로그아웃 생략");
      }

      // 2. Firebase 로그아웃 (Google, Apple 공통)
      await FirebaseAuth.instance.signOut();

      // 3. Google 로그아웃
      await GoogleSignIn().signOut();

      // 4. Kakao 로그아웃
      try {
        await UserApi.instance.logout();
      } catch (e) {
        print("⚠️ Kakao 로그아웃 생략 또는 실패: $e");
      }

      // 5. 토큰 전부 삭제
      await _secureStorage.deleteAll();

      print("✅ 모든 로그아웃 및 토큰 삭제 완료");
    } catch (e) {
      print("❌ 로그아웃 실패: $e");
    }
  }
}
