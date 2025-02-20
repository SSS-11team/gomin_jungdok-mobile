import 'package:flutter/material.dart';
import 'package:gomin_jungdok_mobile/worry_solution/component/widget/selectionButton_widget.dart';

class SolutionDetailsView extends StatefulWidget {
  const SolutionDetailsView({super.key});

  @override
  State<SolutionDetailsView> createState() => _SolutionDetailsViewState();
}

class _SolutionDetailsViewState extends State<SolutionDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.report_gmailerrorred, color: Colors.grey),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('사용자 이름',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('활동 정보', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const Text('AI 표시', style: TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Q. 고민제목이 표시됩니다',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Text('고민설명이 표시됩니다', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(child: Text('설명에 포함된 사진')),
            ),
            const SizedBox(height: 16),
            const Divider(
              color: Colors.grey,
              thickness: 1.0,
              height: 1.0,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SelectionButton(label: '선택지1'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SelectionButton(label: '선택지2'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_fire_department), label: '오늘의 고민'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline), label: '고민등록하기'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: '과거의 고민'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '마이페이지'),
        ],
      ),
    );
  }
}
