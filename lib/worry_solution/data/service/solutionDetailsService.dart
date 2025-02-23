import 'package:flutter/material.dart';
import 'package:gomin_jungdok_mobile/worry_solution/data/model/solutionDetails_model.dart';
import 'package:gomin_jungdok_mobile/worry_solution/data/model/solutionVote_model.dart';
import 'package:gomin_jungdok_mobile/worry_solution/data/repository/solutionDetails_repository.dart';

class Solutiondetailsservice {
  final SolutiondetailsRepository repository;
  SolutionDetails solutionDetailsModel;
  Solutiondetailsservice(this.repository, this.solutionDetailsModel);

  Future<SolutionDetails> fetchSolutionDetails(int postId) async {
    final response = await repository.fetchDetailsSolutionPosts(id: postId);

    debugPrint("[PRINT_SOLUTION_DETAILS] : ${response.data.toString()}");
    if (response.statusCode != 200) {
      print("[ERROR] failed to fetch solutionDetails");
    }

    solutionDetailsModel = response.data!;
    return solutionDetailsModel;
  }
}
