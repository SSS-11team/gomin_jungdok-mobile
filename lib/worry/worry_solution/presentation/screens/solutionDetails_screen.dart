import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gomin_jungdok_mobile/common/const/colors.dart';
import 'package:gomin_jungdok_mobile/common/presentation/router/go_router.dart';
import 'package:gomin_jungdok_mobile/worry/worry_solution/presentation/widget/selectionButton_widget.dart';
import 'package:gomin_jungdok_mobile/worry/worry_solution/provider/solutionDetails_prov.dart';

class SolutionDetailsView extends ConsumerWidget {
  final int postId;
  const SolutionDetailsView({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final solutionDetailsAsync = ref.watch(fetchDetailProvider(postId));
    return SafeArea(
      child: Scaffold(
        backgroundColor: MAIN_BG_COLOR,
        appBar: AppBar(
          backgroundColor: MAIN_BG_COLOR,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: MAIN_TEXT_COLOR),
            onPressed: () {
              router.pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.report_gmailerrorred,
                  color: MAIN_TEXT_COLOR),
              onPressed: () {},
            ),
          ],
        ),
        body: solutionDetailsAsync.when(
          data: (info) {
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
                            backgroundColor: MAIN_TEXT_COLOR,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(info.writerNickname,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(info.createdAt,
                                  style: TextStyle(color: MAIN_TEXT_COLOR)),
                            ],
                          ),
                        ],
                      ),
                      // 현재 AI가 따로 없어 나중에 구현하도록 수정
                      // Text(info.isAi.toString(),
                      //     style: TextStyle(color: MAIN_TEXT_COLOR)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    info.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(info.description,
                      style: TextStyle(color: MAIN_TEXT_COLOR)),
                  const SizedBox(height: 16),
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: info.images != null && info.images!.isNotEmpty
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: info.images!.length,
                            itemBuilder: (context, index) {
                              String imageUrl =
                                  info.images!.values.elementAt(index);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Image.network(imageUrl, fit: BoxFit.cover),
                              );
                            },
                          )
                        : const Center(child: Text('이미지가 없습니다')),
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                    color: MAIN_TEXT_COLOR,
                    thickness: 1.0,
                    height: 1.0,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: SelectionButton(
                          postId: postId,
                          optionNum: 1,
                          label: info.option1Content,
                          voteCount: info.option1Vote,
                          votePercentage: info.option1Percentage!,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SelectionButton(
                          postId: postId,
                          optionNum: 2,
                          label: info.option2Content,
                          voteCount: info.option2Vote,
                          votePercentage: info.option2Percentage!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stackTrace) => Center(
            child: Text("오류 발생"),
          ),
        ),
      ),
    );
  }
}
