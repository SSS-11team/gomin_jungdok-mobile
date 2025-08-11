/*
import 'package:flutter/material.dart';

class PastWorry extends StatelessWidget {
  PastWorry({super.key});

  /// 📌 고민 목록 (제목, 날짜, 선택지 2개)
  final List<Map<String, dynamic>> worries = [
    {
      "title": "남친이랑 있는데 전여친 전화옴",
      "date": "2024-02-20",
      "choices": ["내가 받는다", "남친 시켜서 내 말 전달"]
    },
    {
      "title": "직장 옮겼는데 전여친이 상사임;",
      "date": "2024-02-18",
      "choices": ["퇴사할까?", "걍 다닐까?"]
    },
    {
      "title": "동물 키우고싶긴한데.. 추천좀",
      "date": "2024-02-15",
      "choices": ["강아지 고양이 키우기", "도마뱀 키우기"]
    },
    {
      "title": "이번주 연휴에 뭐하지..",
      "date": "2024-02-10",
      "choices": ["애국하기", "개강 전 여행가기"]
    },
  ];

  /// 🔥 스크롤바를 추가하기 위한 컨트롤러
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Scrollbar(
        controller: _scrollController,
        thumbVisibility: true, // 🔥 스크롤바 항상 보이도록 설정
        thickness: 6, // 🔥 스크롤바 두께 조정
        radius: const Radius.circular(10), // 🔥 스크롤바 둥글게
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              const SizedBox(height: 30),

              /// 📌 스크롤 시 함께 올라가는 "헤더" (AppBar 역할 X)
              const Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Icon(Icons.emoji_events,
                      color: Color(0xFFFA743E), size: 40), // 🏆 트로피 아이콘
                  SizedBox(height: 5),
                  Text(
                    '명예의 고민 전당',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// 📌 고민 리스트 (스크롤 가능)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(), // 내부 스크롤 방지
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: worries.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20), // 고민 사이 간격
                itemBuilder: (context, index) {
                  return _buildWorryCard(
                    index + 1, // Top 순위
                    worries[index]["title"]!,
                    worries[index]["date"]!,
                    worries[index]["choices"]!,
                  );
                },
              ),
              const SizedBox(height: 30), // 마지막 카드 아래 여백 추가
            ],
          ),
        ),
      ),
    );
  }

  /// 고민 카드 UI 위젯
  Widget _buildWorryCard(
      int rank, String title, String date, List<String> choices) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 Top 순위 (좌측 정렬)
          Row(
            children: [
              const Icon(Icons.diamond,
                  color: Colors.cyanAccent, size: 20), // 👑 왕관 아이콘
              const SizedBox(width: 5),
              Text(
                "Top $rank",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8), // 왕관과 제목 사이 간격

          /// 📌 고민 제목 + 날짜 표시
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                date, // 🔥 각 고민에 개별 날짜 적용
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
            ],
          ),
          const SizedBox(height: 10),

          /// 📌 선택지 2개
          Row(
            children: [
              _buildChoiceButton(choices[0]), // 선택지 1
              const SizedBox(width: 10),
              _buildChoiceButton(choices[1]), // 선택지 2
            ],
          ),
        ],
      ),
    );
  }

  /// 선택지 버튼 UI 위젯
  Widget _buildChoiceButton(String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
*/