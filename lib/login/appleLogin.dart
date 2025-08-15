import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart' as dio;
import 'package:gomin_jungdok_mobile/common/const/api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppleAuthService {
  final dio.Dio _dio = dio.Dio();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  /// 🔹 애플 로그인 → Firebase 인증 → 백엔드 전송까지 한 번에 처리
  Future<String?> signInWithApple() async {
    try {
      // 1. 애플 로그인 요청
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      final identityToken = credential.identityToken;
      final authorizationCode = credential.authorizationCode;

      if (identityToken == null || authorizationCode == null) {
        throw Exception("Apple 로그인 토큰이 null입니다.");
      }

      print("✅ Apple Identity Token: $identityToken");
      print("✅ Apple Authorization Code: $authorizationCode");

      // 2. Firebase에 애플 인증 정보로 로그인
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: identityToken,
        accessToken: authorizationCode,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      final firebaseIdToken = await userCredential.user?.getIdToken();

      if (firebaseIdToken == null) {
        throw Exception("Firebase ID 토큰을 가져오지 못했습니다.");
      }

      print("✅ Firebase ID Token: $firebaseIdToken");

      // 3. 백엔드에 ID 토큰 전달
      final response = await _dio.post(
        "$BASE_URL/api/auth/firebase/login",
        options: dio.Options(
          headers: {
            "Authorization": "Bearer $firebaseIdToken", // ✅ 헤더로 전송
          },
        ),
      );

      print("📡 백엔드 응답 상태 코드: ${response.statusCode}");
      print("📡 백엔드 응답 본문: ${response.data}");

      if (response.statusCode == 200 && response.data['jwtAuthToken'] != null) {
        final authToken = response.data['jwtAuthToken'];
        final backendAccessToken = authToken['accessToken'];
        final backendRefreshToken = authToken['refreshToken'];

        print("✅ 백엔드 토큰 발급 성공:");
        print("Backend AccessToken: $backendAccessToken");
        print("Backend RefreshToken: $backendRefreshToken");

        await secureStorage.write(
            key: 'accessToken', value: backendAccessToken);
        await secureStorage.write(
            key: 'refreshToken', value: backendRefreshToken);
        await secureStorage.write(
            key: 'login_provider', value: 'apple'); // 로그인 제공자도 저장

        final nickname = response.data['nickname'] ?? '애플 사용자';
        return nickname;
      } else {
        print("❌ 백엔드 응답 오류 또는 토큰 없음");
        return null;
      }
    } catch (error) {
      print("❌ 애플 로그인 전체 프로세스 실패: $error");
      return null;
    }
  }
}
