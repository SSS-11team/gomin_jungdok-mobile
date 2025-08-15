import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gomin_jungdok_mobile/common/const/api.dart';

class KakaoAuthService {
  final dio.Dio _dio = dio.Dio(dio.BaseOptions(
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
  ));
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// 🔹 카카오 로그인 및 사용자 정보 조회
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
      final refreshToken = token?.refreshToken;

      if (accessToken == null) {
        throw Exception("카카오 액세스 토큰을 가져오지 못했습니다.");
      }

      print("Access Token: $accessToken");
      print("Refresh Token: $refreshToken");
      print("토큰 만료: ${token?.expiresAt}");
      print("✅ 카카오 로그인 성공!");

      // 3. 백엔드 callback 요청 (accessToken 전달)
      final callbackResponse = await _dio.get(
        "$BASE_URL/api/auth/kakao/callback",
        options: dio.Options(headers: {
          "Authorization": "Bearer $accessToken",
        }),
      );
      print("📡 요청 URL: $BASE_URL/api/auth/kakao/callback");
      print("📡 요청 헤더: Authorization: Bearer $accessToken");
      print("📡 [CALLBACK 응답] status: ${callbackResponse.statusCode}");
      print("📡 [CALLBACK 응답] body: ${callbackResponse.data}");

      if (callbackResponse.statusCode == 200 &&
          callbackResponse.data['authToken'] != null) {
        final authToken = callbackResponse.data['authToken'];
        final backendAccessToken = authToken['accessToken'];
        final backendRefreshToken = authToken['refreshToken'];

        // ✅ 토큰 안전 저장
        await _secureStorage.write(
            key: "accessToken", value: backendAccessToken);
        await _secureStorage.write(
            key: "refreshToken", value: backendRefreshToken);
        await _secureStorage.write(
            key: 'login_provider', value: 'kakao'); // 로그인 제공자도 저장

        print("✅ 백엔드에서 나한테 토큰 발급 완료:");
        print("Backend AccessToken: $backendAccessToken");
        print("Backend RefreshToken: $backendRefreshToken");

        // 4. 사용자 정보 요청
        return await fetchUserInfo(backendAccessToken);
      } else {
        print("❌ [CALLBACK] 토큰 발급 실패 or 응답 구조 오류");
        return null;
      }
    } on dio.DioException catch (e) {
      print("❌ DioException (callback): ${e.response?.statusCode}");
      print("📡 응답 본문: ${e.response?.data}");
      return null;
    } catch (error) {
      print("❌ 카카오 로그인 실패: $error");
      return null;
    }
  }

  /// 🔹 저장된 토큰으로 로그인 유지 시도
  Future<String?> loginWithSavedToken() async {
    final accessToken = await _secureStorage.read(key: "accessToken");
    final refreshToken = await _secureStorage.read(key: "refreshToken");

    if (accessToken == null || refreshToken == null) {
      print("❌ 저장된 토큰이 없습니다.");
      return null;
    }

    try {
      print("✅ 저장된 토큰으로 로그인 시도...");
      final userResponse = await _dio.get(
        "$BASE_URL/api/auth/kakao/user",
        options: dio.Options(headers: {
          "Authorization": "Bearer $accessToken",
        }),
      );
      print("📡 사용자 응답 status: ${userResponse.statusCode}");
      print("📡 사용자 응답 body: ${userResponse.data}");

      if (userResponse.statusCode == 200) {
        final user = userResponse.data;
        return user['nickname'];
      } else {
        throw Exception("유저 정보 요청 실패");
      }
    } on dio.DioException catch (e) {
      if (e.response?.statusCode == 401) {
        print("⚠️ 토큰 만료! 재발급 시도 중...");
        return await refreshTokenAndFetchUserInfo(refreshToken);
      } else {
        print("❌ DioException: ${e.message}");
        return null;
      }
    }
  }

  /// 🔹 토큰 재발급 후 사용자 정보 요청
  Future<String?> refreshTokenAndFetchUserInfo(String refreshToken) async {
    try {
      final response = await _dio.post(
        "$BASE_URL/api/auth/kakao/refresh",
        options: dio.Options(headers: {
          "Authorization": "Bearer $refreshToken",
        }),
      );

      if (response.statusCode == 200 && response.data['authToken'] != null) {
        final newAccessToken = response.data['authToken']['accessToken'];
        final newRefreshToken = response.data['authToken']['refreshToken'];

        // ✅ 토큰 갱신
        await _secureStorage.write(key: "accessToken", value: newAccessToken);
        await _secureStorage.write(key: "refreshToken", value: newRefreshToken);

        print("✅ 토큰 재발급 완료");
        return await fetchUserInfo(newAccessToken);
      } else {
        print("❌ 토큰 재발급 실패");
        return null;
      }
    } catch (e) {
      print("❌ 토큰 재발급 요청 실패: $e");
      return null;
    }
  }

  /// 🔹 사용자 정보 요청
  Future<String?> fetchUserInfo(String token) async {
    final userResponse = await _dio.get(
      "$BASE_URL/api/auth/kakao/user",
      options: dio.Options(headers: {
        "Authorization": "Bearer $token",
      }),
    );

    if (userResponse.statusCode == 200) {
      final user = userResponse.data;
      print("✅ 사용자 정보 조회 성공");
      print("닉네임: ${user['nickname']}");
      print("이메일(소셜 ID): ${user['email']}");
      print("가입일시: ${user['createdAt']}");
      return user['nickname'];
    } else {
      throw Exception("사용자 정보 조회 실패");
    }
  }

  /// 🔹 카카오 로그아웃
  Future<void> logout() async {
    try {
      await UserApi.instance.logout();
      await _secureStorage.deleteAll();
      print("✅ 로그아웃 및 토큰 삭제 완료");
    } catch (e) {
      print("❌ 로그아웃 실패: $e");
    }
  }
}
