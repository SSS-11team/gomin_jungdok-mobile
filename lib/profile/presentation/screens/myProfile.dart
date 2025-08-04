import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gomin_jungdok_mobile/common/const/colors.dart';

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
          automaticallyImplyLeading: false, // 뒤로가기 버튼 제거
          title: Container(
            padding: EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/logo.svg',
                  height: 50,
                ),
                SvgPicture.asset(
                  'assets/icons/typo.svg',
                  height: 90,
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Divider(
              thickness: 3,
              color: Colors.grey.shade300,
            ),

            // 프로필 섹션 추가
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  // 프로필 이미지
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(width: 20),
                  // 프로필 정보
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 프로필 이름 추후 수정 필요
                        Text(
                          '주현지',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        // 프로필 수정 버튼
                        GestureDetector(
                          onTap: () {
                            // 프로필 수정 페이지로 이동
                            context.go('/profile/edit');
                          },
                          child: Container(
                            width: double.infinity, // 끝까지 늘리기
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(
                                  255, 255, 209, 191), // 연한 주황색
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                color: MAIN_COLOR, // 더 진한 주황색
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '프로필 수정',
                              textAlign: TextAlign.center, // 텍스트 중앙 정렬
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 3,
              color: Colors.grey.shade300,
            ),

            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                children: [
                  _buildTextButton(context, '내가 쓴 글 보기', '/'),
                  Divider(
                    thickness: 1,
                    color: Colors.grey.shade300,
                    indent: 10,
                    endIndent: 10,
                  ),
                  _buildTextButton(context, '알림 설정', '/'),
                  Divider(
                    thickness: 1,
                    color: Colors.grey.shade300,
                    indent: 10,
                    endIndent: 10,
                  ),
                  _buildTextButton(context, '로그아웃', '/'),
                  Divider(
                    thickness: 1,
                    color: Colors.grey.shade300,
                    indent: 10,
                    endIndent: 10,
                  ),
                  _buildTextButton(context, '약관 정보', '/terms'),
                  Divider(
                    thickness: 1,
                    color: Colors.grey.shade300,
                    indent: 10,
                    endIndent: 10,
                  ),
                  _buildTextButton(context, '탈퇴하기', '/'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextButton(BuildContext context, String title, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          context.go(route); // 전달받은 라우트로 이동
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            IconButton(
                onPressed: () {
                  context.go(route);
                },
                icon: Icon(Icons.chevron_right))
          ],
        ),
      ),
    );
  }
}
