import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/provider/todayWorry_prov.dart';

class TodayWorryListScreens extends ConsumerWidget {
  const TodayWorryListScreens({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayWorryPosts = ref.watch(fetchTodayWorryPostsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('오늘의 고민 목록')),
      body: todayWorryPosts.when(
        data: (todayWorryList) {
          return ListView.builder(
            itemCount: todayWorryList.length,
            itemBuilder: (context, index) {
              final post = todayWorryList[index];
              return ListTile(
                title: Text(post.title),
                subtitle: Text(post.description),
                onTap: () {
                  // 상세 페이지로 이동
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TodayWorryDetailsScreen(postId: post.postId),
                    ),
                  );
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('데이터를 불러오지 못했습니다.')),
      ),
    );
  }
}

class TodayWorryDetailsScreen extends StatelessWidget {
  final int postId;

  const TodayWorryDetailsScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('고민 상세 정보')),
      body: Center(child: Text('Post ID: $postId')), // 실제 상세 내용 불러오기 구현 필요
    );
  }
}
