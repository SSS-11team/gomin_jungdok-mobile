import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:dio/dio.dart';
import 'package:gomin_jungdok_mobile/common/const/api.dart';

class KakaoAuthService {
  final Dio _dio = Dio();

  /// 🔹 카카오 로그인 요청 및 사용자 정보 조회
  Future<String?> loginWithKakao() async {
    try {
      // 1. 카카오 로그인 시도
      if (await isKakaoTalkInstalled()) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }

      // 2. 액세스 토큰 추출
      final token = await TokenManagerProvider.instance.manager.getToken();
      final accessToken = token?.accessToken;

      if (accessToken == null) {
        throw Exception("카카오 액세스 토큰을 가져오지 못했습니다.");
      }
      print("Access Token: ${token?.accessToken}");
      print("Refresh Token: ${token?.refreshToken}");
      print("토큰 만료: ${token?.expiresAt}");
      print("✅ 카카오 로그인 성공! 액세스 토큰: $accessToken");

      // 3. 백엔드 callback 요청 (accessToken 전달)
      final callbackResponse = await _dio.get(
        "$BASE_URL/api/auth/kakao/callback",
        options: Options(headers: {
          "Authorization": "Bearer $accessToken",
        }),
      );

      if (callbackResponse.statusCode == 200 &&
          callbackResponse.data['authToken'] != null) {
        final authToken = callbackResponse.data['authToken'];
        final backendAccessToken = authToken['accessToken'];
        final backendRefreshToken = authToken['refreshToken'];

        print("✅ 백엔드에서 나한테 토큰 발급 완료:");
        print("Backend AccessToken: $backendAccessToken");
        print("Backend RefreshToken: $backendRefreshToken");

        // 4. 백엔드에 유저 정보 요청
        final userResponse = await _dio.get(
          "$BASE_URL/api/auth/kakao/user",
          options: Options(headers: {
            "Authorization": "Bearer $backendAccessToken",
          }),
        );

        if (userResponse.statusCode == 200) {
          final user = userResponse.data;

          print("✅ 사용자 정보 조회 성공");
          print("닉네임: ${user['nickname']}");
          print("이메일(소셜 ID): ${user['socialId']}");
          print("가입일시: ${user['createdAt']}");

          return user['nickname']; // 닉네임 리턴 (화면 출력용)
        } else {
          throw Exception("사용자 정보 조회 실패");
        }
      } else {
        throw Exception("백엔드 토큰 발급 실패");
      }
    } catch (error) {
      print("❌ 카카오 로그인 실패: $error");
      return null;
    }
  }

  /// 🔹 카카오 로그아웃
  Future<void> logout() async {
    try {
      await UserApi.instance.logout();
      print("✅ 카카오 로그아웃 성공");
    } catch (e) {
      print("❌ 로그아웃 실패: $e");
    }
  }
}
