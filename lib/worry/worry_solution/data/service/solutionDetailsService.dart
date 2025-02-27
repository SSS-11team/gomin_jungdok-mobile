import 'package:flutter/material.dart';
import 'package:gomin_jungdok_mobile/worry/worry_solution/data/model/solutionDetails_model.dart';
import 'package:gomin_jungdok_mobile/worry/worry_solution/data/model/solutionVote_model.dart';
import 'package:gomin_jungdok_mobile/worry/worry_solution/data/repository/solutionDetails_repository.dart';

class SolutionDetailsService {
  final SolutionDetailsRepository repository;

  SolutionDetailsService(this.repository);

  Future<SolutionDetails> fetchSolutionDetails(int postId) async {
    final response = await repository.fetchDetailsSolutionPosts(id: postId);

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
          "Failed to fetch solution details - ErrorCode: ${response.statusCode}");
    }

    return response.data!;
  }

  Future<SolutionVote> voteSolution(int postId, int voteNum) async {
    final SolutionVote solutionVoteModel;
    final response =
        await repository.solutionVote(id: postId, vote: {"vote": voteNum});
    debugPrint("[ERROR] Response error! :${response.statusCode.toString()}");
    if (response.statusCode != 201) {
      debugPrint(
          "[ERROR] Failed to vote solution - errorCode : ${response.statusCode}");
    }

    solutionVoteModel = response.data!;
    return solutionVoteModel;
  }
}
