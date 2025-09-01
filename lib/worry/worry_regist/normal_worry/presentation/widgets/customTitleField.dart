// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';

// class CustomTitleField extends StatefulWidget {
//   final TextEditingController controller; // 🔥 외부에서 컨트롤러를 받음

//   const CustomTitleField({required this.controller, super.key});

//   @override
//   _CustomTitleFieldState createState() => _CustomTitleFieldState();
// }

// class _CustomTitleFieldState extends State<CustomTitleField> {
//   bool _isFocused = false;
//   final FocusNode _focusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(() {
//       setState(() {
//         _isFocused = _focusNode.hasFocus;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 5),
//         TextField(
//           focusNode: _focusNode,
//           controller: widget.controller, // 🔥 외부에서 받은 컨트롤러 사용
//           maxLength: 20,
//           decoration: InputDecoration(
//             counterStyle: TextStyle(color: Color(0xFFFA743E), fontSize: 12),
//             hintText: '제목을 입력하세요',
//             hintStyle: TextStyle(
//               fontSize: 20,
//               color: Colors.grey,
//             ),
//             border: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: _isFocused ? Color(0xFFFA743E) : Colors.grey,
//                 width: 2,
//               ),
//             ),
//             enabledBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Colors.grey,
//                 width: 1,
//               ),
//             ),
//             focusedBorder: UnderlineInputBorder(
//               borderSide: BorderSide(
//                 color: Color(0xFFFA743E),
//                 width: 2,
//               ),
//             ),
//             counterText: _isFocused ? null : "", // 글자수 제한 표시를 입력 중일 때만
//           ),
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold, // 입력 시 볼드 처리
//           ),
//         ),
//       ],
//     );
//   }
// }

// class CustomIntroField extends StatefulWidget {
//   final TextEditingController controller;

//   const CustomIntroField({super.key, required this.controller});

//   @override
//   State<CustomIntroField> createState() => _CustomIntroFieldState();
// }

// class _CustomIntroFieldState extends State<CustomIntroField> {
//   bool _isFocused = false;
//   final FocusNode _focusNode = FocusNode();

//   @override
//   void initState() {
//     super.initState();
//     _focusNode.addListener(() {
//       setState(() {
//         _isFocused = _focusNode.hasFocus;
//       });
//     });
//   }

//   @override
//   void dispose() {
//     _focusNode.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 5),
//         Stack(
//           children: [
//             Container(
//               height: 200,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 border: Border.all(color: Colors.white),
//                 borderRadius: BorderRadius.circular(0),
//               ),
//               child: TextField(
//                 focusNode: _focusNode,
//                 controller: widget.controller,
//                 maxLines: 4,
//                 inputFormatters: [
//                   LengthLimitingTextInputFormatter(100),
//                 ],
//                 onChanged: (text) {
//                   setState(() {});
//                 },
//                 decoration: InputDecoration(
//                   hintText: '100자 이내로 고민에 대해 설명해주세요.\n고민은 당일 24시가 되면 사라집니다.',
//                   hintStyle: const TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey,
//                   ),
//                   border: InputBorder.none,
//                   counterText: "",
//                 ),
//                 style: const TextStyle(
//                   fontSize: 12,
//                 ),
//               ),
//             ),
//             Positioned(
//               right: 10,
//               bottom: 5,
//               child: AnimatedOpacity(
//                 duration: Duration(milliseconds: 200),
//                 opacity: _isFocused ? 1.0 : 0.0,
//                 child: Text(
//                   "${widget.controller.text.length}/100",
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Color(0xFFFA743E),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class ImagePickerWidget extends StatelessWidget {
//   final List<XFile> selectedImages;
//   final Function(List<XFile>) onImageSelected;

//   ImagePickerWidget(
//       {super.key, required this.selectedImages, required this.onImageSelected});

//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickImages(BuildContext context) async {
//     try {
//       final List<XFile> images = await _picker.pickMultiImage();

//       if (images.isEmpty) {
//         print("이미지가 선택되지 않음.");
//         return;
//       }

//       List<XFile> validImages = images.where((image) {
//         return image.path.isNotEmpty && File(image.path).existsSync();
//       }).toList();

//       if (selectedImages.length + validImages.length > 4) {
//         int spaceLeft = 4 - selectedImages.length;
//         onImageSelected([...selectedImages, ...validImages.take(spaceLeft)]);
//       } else {
//         onImageSelected([...selectedImages, ...validImages]);
//       }
//     } catch (e) {
//       print("이미지 선택 중 오류 발생: $e");
//     }
//   }

//   void _removeImage(int index) {
//     List<XFile> updatedList = List.from(selectedImages)..removeAt(index);
//     onImageSelected(updatedList);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         GestureDetector(
//           onTap: () => _pickImages(context),
//           child: Container(
//             width: 60,
//             height: 60,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(10),
//               border:
//                   Border.all(color: const Color.fromARGB(255, 189, 189, 189)),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Icon(Icons.camera_alt, size: 24, color: Colors.grey),
//                 Text.rich(TextSpan(children: [
//                   TextSpan(
//                     text: "${selectedImages.length}",
//                     style: TextStyle(
//                       color: Color(0xFFFA743E),
//                       fontSize: 12,
//                     ),
//                   ),
//                   TextSpan(
//                       text: "/4",
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 12,
//                       )),
//                 ])),
//               ],
//             ),
//           ),
//         ),
//         SizedBox(width: 10),

//         // 선택한 이미지 리스트
//         Expanded(
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: selectedImages.asMap().entries.map((entry) {
//                 int index = entry.key;
//                 XFile image = entry.value;
//                 return Stack(
//                   alignment: Alignment.topRight,
//                   children: [
//                     ClipRRect(
//                       borderRadius: BorderRadius.circular(10),
//                       child: File(image.path).existsSync()
//                           ? Image.file(
//                               File(image.path), // ✅ 경로 정리 후 Image.file 사용
//                               width: 60,
//                               height: 60,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) =>
//                                   Icon(Icons.error, size: 60),
//                             )
//                           : Icon(Icons.error,
//                               size: 60), // 파일이 존재하지 않으면 에러 아이콘 표시
//                     ),
//                     GestureDetector(
//                       onTap: () => _removeImage(index),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.black54,
//                         ),
//                         child: Icon(Icons.close, size: 16, color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 );
//               }).toList(),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
