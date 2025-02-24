import 'package:flutter/material.dart';
import 'package:gomin_jungdok_mobile/worry_solution/data/model/solutionDetails_model.dart';
import 'package:gomin_jungdok_mobile/worry_solution/data/model/solutionVote_model.dart';
import 'package:gomin_jungdok_mobile/worry_solution/data/repository/solutionDetails_repository.dart';

class SolutionDetailsService {
  final SolutionDetailsRepository repository;

  SolutionDetailsService(this.repository);

  Future<SolutionDetails> fetchSolutionDetails(int postId) async {
    SolutionDetails solutionDetailsModel;
    final response = await repository.fetchDetailsSolutionPosts(id: postId);

    if (response.statusCode != 200 && response.statusCode != 201) {
      debugPrint(
          "[ERROR] failed to fetch solutionDetails - errorCode : ${response.statusCode}");
    }

    solutionDetailsModel = response.data!;
    return solutionDetailsModel;
  }

  Future<SolutionVote> voteSolution(
      int postId, Map<String, dynamic> vote) async {
    final SolutionVote solutionVoteModel;
    final response = await repository.solutionVote(id: postId, vote: vote);
    debugPrint(response.statusCode.toString());
    if (response.statusCode != 201) {
      print(
          "[ERROR] Failed to vote solution - errorCode : ${response.statusCode}");
    }
    solutionVoteModel = response.data!;
    return solutionVoteModel;
  }
}
