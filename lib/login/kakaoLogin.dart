import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:dio/dio.dart';
import 'package:gomin_jungdok_mobile/common/const/api.dart';

class KakaoAuthService {
  final Dio _dio = Dio();

  /// 🔹 카카오 로그인 요청
  Future<String?> loginWithKakao() async {
    try {
      // 카카오톡이 설치되어 있으면 앱으로 로그인, 없으면 웹 로그인
      if (await isKakaoTalkInstalled()) {
        await UserApi.instance.loginWithKakaoTalk();
      } else {
        await UserApi.instance.loginWithKakaoAccount();
      }

      // ✅ 카카오 액세스 토큰 가져오기
      var token = await TokenManagerProvider.instance.manager.getToken();
      String? accessToken = token?.accessToken;

      if (accessToken == null) {
        throw Exception("카카오 액세스 토큰을 가져오지 못했습니다.");
      } else {
        print("✅ 카카오 로그인 성공! 액세스 토큰: $accessToken");
      }
      // 🔹 백엔드에 사용자 정보 요청
      Response response = await _dio.get(
        "$BASE_URL/api/auth/kakao/login",
        // options: Options(headers: {
        //   "Authorization": "Bearer $accessToken",
        // }),
      );

      if (response.statusCode == 302 && response.data != null) {
        print("✅ 로그인 성공");
      } else {
        throw Exception("사용자 정보 조회 실패");
      }
    } catch (error) {
      print("❌ 카카오 로그인 실패: $error");
      return null;
    }
  }

  /// 🔹 로그아웃 요청
  Future<void> logout() async {
    try {
      await UserApi.instance.logout();
      print("✅ 카카오 로그아웃 완료");

      // 🔹 백엔드 로그아웃 요청
      await _dio.post("$BASE_URL/api/auth/kakao/logout");
    } catch (error) {
      print("❌ 로그아웃 실패: $error");
    }
  }
}
