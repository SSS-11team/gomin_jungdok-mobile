import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gomin_jungdok_mobile/common/const/colors.dart';
import 'package:gomin_jungdok_mobile/worry/worry_solution/provider/solutionDetails_prov.dart';

// class SelectionButton extends ConsumerWidget {
//   final int postId;
//   final String label;
//   final int optionNum;
//   final int voteCount;
//   final String votePercentage;

//   const SelectionButton(
//       {super.key,
//       required this.postId,
//       required this.label,
//       required this.optionNum,
//       required this.voteCount,
//       required this.votePercentage});

//   void _showConfirmationDialog(BuildContext context, WidgetRef ref) {
//     final service = ref.read(detailServiceProvider);

//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.grey[100],
//           title: Text('$label을 선택하시겠습니까?',
//               style: const TextStyle(
//                   color: MAIN_TEXT_COLOR,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20.0)),
//           content: const Text('투표 후에는 다시 투표할 수 없습니다',
//               style: TextStyle(color: MAIN_TEXT_COLOR)),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 '취소',
//                 style: TextStyle(color: MAIN_TEXT_COLOR),
//               ),
//             ),
//             TextButton(
//               onPressed: () async {
//                 ref
//                     .read(selectedOptionProvider.notifier)
//                     .selectOption(postId, optionNum);
//                 // .seletedOption(optionNum);
//                 await service.voteSolution(1, optionNum);
//                 ref.invalidate(fetchDetailProvider(1));

//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 '확인',
//                 style: TextStyle(color: MAIN_TEXT_COLOR),
//               ),
//             ),
//           ],
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
//         );
//       },
//     );
//   }

// //
//   void _showAlreadyVotedDialog(BuildContext context, WidgetRef ref) {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.grey[100],
//           title: const Text(
//             "투표 완료",
//             style: TextStyle(
//               color: MAIN_TEXT_COLOR,
//               fontWeight: FontWeight.bold,
//               fontSize: 20.0,
//             ),
//           ),
//           content: const Text(
//             "이미 투표를 완료하셨습니다.",
//             style: TextStyle(color: MAIN_TEXT_COLOR),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 "확인",
//                 style: TextStyle(color: MAIN_TEXT_COLOR),
//               ),
//             ),
//           ],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(0),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selectedOption = ref.watch(selectedOptionProvider);
//     final isSelected = selectedOption == optionNum;
//     final isDisabled = selectedOption != null;

//     return ElevatedButton(
//       onPressed: () {
//         if (!isSelected && !isDisabled) {
//           _showConfirmationDialog(context, ref);
//         } else {
//           _showAlreadyVotedDialog(context, ref);
//         }
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: isSelected ? MAIN_TEXT_COLOR : Colors.grey[200],
//         // backgroundColor: Colors.grey[200],
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.zero,
//         ),
//       ),
//       child: Column(
//         children: [
//           Text(label,
//               style: const TextStyle(
//                   color: BLACK_COLOR, fontWeight: FontWeight.bold)),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [Text(voteCount.toString()), Text("($votePercentage)")],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SelectionButton extends ConsumerWidget {
//   final int postId;
//   final String label;
//   final int optionNum;
//   final int voteCount;
//   final String votePercentage;

//   const SelectionButton({
//     super.key,
//     required this.postId,
//     required this.label,
//     required this.optionNum,
//     required this.voteCount,
//     required this.votePercentage,
//   });

//   void _showConfirmationDialog(BuildContext context, WidgetRef ref) {
//     final service = ref.read(detailServiceProvider);

//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.grey[100],
//           title: Text('$label을 선택하시겠습니까?',
//               style: const TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 20.0)),
//           content: const Text('투표 후에는 다시 투표할 수 없습니다',
//               style: TextStyle(color: Colors.black)),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 '취소',
//                 style: TextStyle(color: Colors.black),
//               ),
//             ),
//             TextButton(
//               onPressed: () async {
//                 // ✅ 현재 게시글(postId)에 대해 선택 상태 변경
//                 ref
//                     .read(selectedOptionProvider.notifier)
//                     .selectOption(postId, optionNum);

//                 await service.voteSolution(postId, optionNum);
//                 ref.invalidate(fetchDetailProvider(postId));

//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 '확인',
//                 style: TextStyle(color: Colors.black),
//               ),
//             ),
//           ],
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
//         );
//       },
//     );
//   }

//   void _showAlreadyVotedDialog(BuildContext context) {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.grey[100],
//           title: const Text(
//             "투표 완료",
//             style: TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.bold,
//               fontSize: 20.0,
//             ),
//           ),
//           content: const Text(
//             "이미 투표를 완료하셨습니다.",
//             style: TextStyle(color: Colors.black),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text(
//                 "확인",
//                 style: TextStyle(color: Colors.black),
//               ),
//             ),
//           ],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(0),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final selectedOptions = ref.watch(selectedOptionProvider);
//     final isSelected = selectedOptions[postId] == optionNum;
//     final isDisabled = selectedOptions[postId] != null;

//     return ElevatedButton(
//       onPressed: () {
//         if (!isSelected && !isDisabled) {
//           _showConfirmationDialog(context, ref);
//         } else {
//           _showAlreadyVotedDialog(context);
//         }
//       },
//       style: ElevatedButton.styleFrom(
//         backgroundColor: isSelected ? Colors.grey[500] : Colors.grey[200],
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//       ),
//       child: Column(
//         children: [
//           Text(label,
//               style: const TextStyle(
//                   color: Colors.black, fontWeight: FontWeight.bold)),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [Text(voteCount.toString()), Text("($votePercentage)")],
//           ),
//         ],
//       ),
//     );
//   }
// }
class SelectionButton extends ConsumerWidget {
  final int postId;
  final String label;
  final int optionNum;
  final int voteCount;
  final String votePercentage;

  const SelectionButton({
    super.key,
    required this.postId,
    required this.label,
    required this.optionNum,
    required this.voteCount,
    required this.votePercentage,
  });

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
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0)),
          content: const Text('투표 후에는 다시 투표할 수 없습니다',
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                '취소',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () async {
                // ✅ 현재 게시글(postId)에 대해 선택 상태 변경
                ref
                    .read(selectedOptionProvider.notifier)
                    .selectOption(postId, optionNum);

                await service.voteSolution(postId, optionNum);
                ref.invalidate(fetchDetailProvider(postId));

                Navigator.of(context).pop();
              },
              child: const Text(
                '확인',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        );
      },
    );
  }

  void _showAlreadyVotedDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[100],
          title: const Text(
            "투표 완료",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          content: const Text(
            "이미 투표를 완료하셨습니다.",
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                "확인",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOptions = ref.watch(selectedOptionProvider);
    final hasVoted = selectedOptions[postId] != null;
    final isSelected = selectedOptions[postId] == optionNum;
    final isDisabled = hasVoted;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0), // ✅ 버튼 좌우 여백 추가
      child: SizedBox(
        width: 100, // ✅ 버튼 크기 동일하게 유지
        height: 70, // ✅ 높이 충분히 확보하여 Overflow 해결
        child: ElevatedButton(
          onPressed: () {
            if (!isSelected && !isDisabled) {
              _showConfirmationDialog(context, ref);
            } else {
              _showAlreadyVotedDialog(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected
                ? Color.fromARGB(255, 255, 222, 209)
                : Colors.white, // ✅ 선택 시 연한 주황색 배경
            side: BorderSide(
              color: isSelected
                  ? Color(0xFFFA743E)
                  : Colors.black26, // ✅ 선택 시 주황색 테두리, 기본은 연한 회색
              width: isSelected ? 1.5 : 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // ✅ 버튼을 살짝 둥글게
            ),
            elevation: 0, // ✅ 그림자 제거하여 깔끔한 디자인 유지
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // ✅ 내부 크기 자동 조정
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration:
                    const Duration(milliseconds: 200), // ✅ 부드럽게 올라가도록 애니메이션 추가
                padding: EdgeInsets.only(
                    bottom: hasVoted ? 6 : 0), // ✅ 선택 후 텍스트 위로 이동
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87, // ✅ 글자는 항상 검은색 유지
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (hasVoted)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center, // ✅ 중앙 정렬
                  children: [
                    Text(
                      voteCount.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(width: 4), // ✅ 숫자와 퍼센트 사이 여백 추가
                    Text(
                      "($votePercentage)", // ✅ 퍼센트 괄호 포함
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
