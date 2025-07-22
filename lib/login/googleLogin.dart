import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart' as dio;
import 'package:gomin_jungdok_mobile/common/const/api.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final dio.Dio _dio = dio.Dio();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<String?> signInWithGoogle() async {
    try {
      // 1. 사용자 구글 로그인 시도
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("❌ 사용자가 구글 로그인을 취소했습니다.");
        return null;
      }

      // 2. 구글 인증 토큰 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // 3. Firebase로 로그인 처리
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // 4. Firebase ID Token 획득
      final firebaseIdToken = await userCredential.user?.getIdToken();
      if (firebaseIdToken == null)
        throw Exception("Firebase ID 토큰을 가져오지 못했습니다.");

      print("✅ Firebase ID Token: $firebaseIdToken");

      // 5. 백엔드에 ID Token 전송 (헤더)
      final response = await _dio.post(
        "$BASE_URL/api/auth/firebase/login",
        options: dio.Options(
          headers: {
            "Authorization": "Bearer $firebaseIdToken",
          },
        ),
      );

      print("📡 백엔드 응답 상태 코드: ${response.statusCode}");
      print("📡 백엔드 응답 본문: ${response.data}");

      // 6. 백엔드 JWT 토큰 수신 및 처리
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
            key: 'login_provider', value: 'google'); // 로그인 제공자도 저장

        final nickname = response.data['nickname'] ?? '구글 사용자';
        return nickname;
      } else {
        print("❌ 백엔드 응답 오류 또는 토큰 없음");
        return null;
      }
    } catch (e) {
      print("❌ Google 로그인 전체 프로세스 실패: $e");
      return null;
    }
  }
}
