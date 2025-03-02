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
            mainAxisSize: MainAxisSize.min, // ✅ 내부 위젯 크기에 맞게 자동 조정
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                // ✅ 높이 강제 조정 (Overflow 방지)
                height: 20, // 🔥 글자 크기에 맞게 적절한 높이 설정
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14, // 🔥 글자 크기 줄여서 Overflow 방지
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (hasVoted)
                Padding(
                  padding: const EdgeInsets.only(top: 2), // 🔥 여백 최소화
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min, // ✅ 내부 크기에 맞게 조정
                    children: [
                      Flexible(
                        // ✅ 텍스트 길이에 맞게 자동 줄바꿈
                        child: Text(
                          voteCount.toString(),
                          style: const TextStyle(
                            fontSize: 12, // 🔥 글자 크기 조정
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        // ✅ 퍼센트도 자동 크기 조정
                        child: Text(
                          "($votePercentage)",
                          style: TextStyle(
                            fontSize: 12, // 🔥 글자 크기 조정
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
