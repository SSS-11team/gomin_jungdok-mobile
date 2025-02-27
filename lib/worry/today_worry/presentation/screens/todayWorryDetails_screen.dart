import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/data/model/todayWorry_model.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/data/model/todayWorryDetails_model.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/data/service/todayWorry_service.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/data/repository/todayWorry_repository.dart';
import 'package:gomin_jungdok_mobile/common/provider/common_prov.dart';
import 'package:gomin_jungdok_mobile/worry/today_worry/provider/todayWorry_prov.dart';
import 'package:gomin_jungdok_mobile/worry/worry_solution/presentation/screens/solutionDetails_screen.dart';

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

class TodayWorryDetailsScreen extends ConsumerWidget {
  final int postId;

  const TodayWorryDetailsScreen({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todayWorryDetails =
        ref.watch(fetchTodayWorryDetailsPostProvider(postId));

    return Scaffold(
      appBar: AppBar(title: Text('고민 상세 정보')),
      body: todayWorryDetails.when(
        data: (details) {
          return Padding(
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
                          children: [
                            Text(details.postTitle,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(details.postDesc,
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: details.imageUrls != null &&
                          details.imageUrls!.isNotEmpty
                      ? ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: details.imageUrls!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(details.imageUrls![index],
                                  fit: BoxFit.cover),
                            );
                          },
                        )
                      : const Center(child: Text('이미지가 없습니다')),
                ),
                const SizedBox(height: 16),
                const Divider(thickness: 1.0),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: details.voteResults.map((vote) {
                    return Expanded(
                      child: Column(
                        children: [
                          Text(vote.option,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("투표율: ${vote.percentage}%"),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('오류 발생')),
      ),
    );
  }
}
