import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AiWorry extends StatelessWidget {
  const AiWorry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경 흰색
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          color: Colors.white, // 🔥 AppBar 배경 고정
          child: SafeArea(
            child: AppBar(
              backgroundColor:
                  Colors.transparent, // 🔥 투명하게 해서 Container 색상을 유지
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  context.go('/');
                },
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Divider(
            color: Colors.grey,
            thickness: 1,
            height: 1,
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 250,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey), // 회색 테두리
                        borderRadius: BorderRadius.circular(5), // 모서리 둥글게
                        color: Colors.white, // 박스 배경 흰색
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 40,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "사진 추가하기",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// 버튼을 화면 하단 중앙에 배치
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30), // 하단 여백 추가
              child: SizedBox(
                width: 350, // 버튼의 너비 조절 (예제: 200px)
                height: 50, // 버튼의 높이 조절
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0), // 버튼 모서리 둥글게
                    ),
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('분석 시작하기'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
