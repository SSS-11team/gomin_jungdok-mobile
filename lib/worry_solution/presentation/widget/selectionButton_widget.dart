import 'package:flutter/material.dart';
import 'package:gomin_jungdok_mobile/common/component/colors.dart';

class SelectionButton extends StatelessWidget {
  final String label;
  final int voteCount;
  final String votePercentage;
  const SelectionButton(
      {super.key,
      required this.label,
      required this.voteCount,
      required this.votePercentage});

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[100],
          title: Text('$label을 선택하시겠습니까?',
              style: const TextStyle(
                  color: MAIN_TEXT_COLOR,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0)),
          content: const Text('투표 후에는 다시 투표할 수 없습니다',
              style: TextStyle(color: MAIN_TEXT_COLOR)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '취소',
                style: TextStyle(color: MAIN_TEXT_COLOR),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '확인',
                style: TextStyle(color: MAIN_TEXT_COLOR),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _showConfirmationDialog(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(
                  color: BLACK_COLOR, fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text(voteCount.toString()), Text("($votePercentage)")],
          ),
        ],
      ),
    );
  }
}
