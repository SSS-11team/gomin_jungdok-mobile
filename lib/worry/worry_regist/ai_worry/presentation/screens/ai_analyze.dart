/*
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AiAnalyze extends StatefulWidget {
  const AiAnalyze({super.key});

  @override
  _AiAnalyzeState createState() => _AiAnalyzeState();
}

class _AiAnalyzeState extends State<AiAnalyze> {
  int? _selectedTitleIndex; // 선택한 고민 제목 index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          color: Colors.white,
          child: SafeArea(
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  context.go('/aiWorry');
                },
              ),
            ),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(thickness: 1, color: Colors.grey),
          SizedBox(
            height: 80,
          ),

          // 📌 고민 제목 리스트 (AI 추천)
          Column(
            children: List.generate(3, (index) {
              final bool isSelected = _selectedTitleIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTitleIndex = index; // ✅ 리스트 전체 터치 시 선택 가능
                  });
                },
                child: Container(
                  width: double.infinity, // ✅ 가로 전체 차지
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFFF0EB)
                        : Colors.transparent, // ✅ 선택된 항목 배경 확장
                    border: Border(
                      bottom: const BorderSide(
                          color: Colors.grey, width: 1), // ✅ 아래 Divider 포함
                    ),
                  ),
                  child: Column(
                    children: [
                      // ✅ 첫 번째 항목인 경우, 위 Divider를 포함하여 배경과 자연스럽게 연결
                      if (index == 0)
                        const Divider(
                          thickness: 1,
                          color: Colors.grey,
                          height: 0, // ✅ 불필요한 여백 제거
                        ),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20), // ✅ 내부 여백 추가
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "AI가 추천하는 제목 ${index + 1}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "고민제목이 표시됩니다",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: isSelected
                                        ? const Color(0xFFFA743E)
                                        : Colors.black,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            Radio<int>(
                              value: index,
                              groupValue: _selectedTitleIndex,
                              activeColor: const Color(0xFFFA743E),
                              onChanged: (int? value) {
                                setState(() {
                                  _selectedTitleIndex = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),

          const Spacer(), // 버튼을 아래로 밀어주는 역할

          // 📌 하단 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20), // ✅ 버튼 패딩 추가
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 다시 추천 받기 버튼
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedTitleIndex = null; // 선택 초기화
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      backgroundColor: Colors.grey.shade500,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('다시 추천 받기'),
                  ),
                ),

                // 고민 작성하기 버튼
                SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _selectedTitleIndex != null
                        ? () {
                            // TODO: 고민 작성하기 로직 추가
                            print("고민 작성 화면으로 이동");
                          }
                        : null, // 선택 안하면 비활성화
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      backgroundColor: _selectedTitleIndex != null
                          ? const Color(0xFFFA743E)
                          : Colors.grey.shade300,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('고민 작성하기'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20), // 하단 여백 추가
        ],
      ),
    );
  }
}
*/