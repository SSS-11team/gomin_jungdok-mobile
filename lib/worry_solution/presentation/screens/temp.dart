import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gomin_jungdok_mobile/worry_solution/data/model/solutionDetails_model.dart';
import 'package:gomin_jungdok_mobile/worry_solution/provider/solutionDetails_prov.dart';

class SolutionDetailsViews extends ConsumerWidget {
  final int postId;

  const SolutionDetailsViews({super.key, required this.postId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final solutionDetailsAsync = ref.watch(fetchDetailProvider(postId));

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.grey),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: solutionDetailsAsync.when(
        data: (solutionDetails) =>
            _buildSolutionDetails(context, solutionDetails),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text("오류 발생: $error")),
      ),
    );
  }

  Widget _buildSolutionDetails(
      BuildContext context, SolutionDetails solutionDetails) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Q. ${solutionDetails.title}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(solutionDetails.description,
              style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
