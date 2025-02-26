import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gomin_jungdok_mobile/common/component/colors.dart';
import 'package:gomin_jungdok_mobile/worry_solution/provider/solutionDetails_prov.dart';

class SelectionButton extends ConsumerWidget {
  final String label;
  final int optionNum;
  final int voteCount;
  final String votePercentage;

  const SelectionButton(
      {super.key,
      required this.label,
      required this.optionNum,
      required this.voteCount,
      required this.votePercentage});

  void _showConfirmationDialog(BuildContext context, WidgetRef ref) {
    final service = ref.read(detailServiceProvider);

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
              onPressed: () async {
                ref
                    .read(selectedOptionProvider.notifier)
                    .seletedOption(optionNum);
                await service.voteSolution(1, {"vote": optionNum});
                ref.invalidate(fetchDetailProvider(1));

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

  void _showAlreadyVotedDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("투표 완료"),
          content: const Text("이미 투표를 완료하셨습니다."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("확인"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOption = ref.watch(selectedOptionProvider);
    final isSelected = selectedOption == optionNum;
    final isDisabled = selectedOption != null; // 이미 선택된 옵션이 있는지 확인

    return ElevatedButton(
      onPressed: () {
        if (!isSelected && !isDisabled) {
          _showConfirmationDialog(context, ref);
        } else {
          _showAlreadyVotedDialog(context, ref);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? MAIN_TEXT_COLOR : Colors.grey[200],
        // backgroundColor: Colors.grey[200],
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
