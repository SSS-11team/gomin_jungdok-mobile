import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gomin_jungdok_mobile/common/const/api.dart';
import 'package:gomin_jungdok_mobile/common/presentation/router/go_router.dart';
import 'package:gomin_jungdok_mobile/worry/worry_regist/component/widgets/tooltip_screen.dart';
import 'package:gomin_jungdok_mobile/worry/worry_solution/presentation/screens/mainSolution_screens.dart';
import 'package:image_picker/image_picker.dart';

class NormalWorry extends ConsumerStatefulWidget {
  const NormalWorry({super.key});

  @override
  _NormalWorryState createState() => _NormalWorryState();
}

class _NormalWorryState extends ConsumerState<NormalWorry> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _introController = TextEditingController();
  // int _introTextLength = 0;
  int _focusedChoiceIndex = -1; // 선택된 선택지 인덱스
  final List<TextEditingController> _choiceControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  final List<FocusNode> _choiceFocusNodes = [FocusNode(), FocusNode()];
  final List<XFile> _selectedImages = [];
// final ImagePicker _picker = ImagePicker();

  final Dio _dio = Dio(); // 서버와의 통신을 위함!
  final String apiUrl = BASE_URL;

  @override
  void initState() {
    super.initState();
    _introController.addListener(() {
      setState(() {});
    });
    for (var i = 0; i < _choiceControllers.length; i++) {
      _choiceControllers[i].addListener(() {
        setState(() {});
      });
      _choiceFocusNodes[i].addListener(() {
        setState(() {
          _focusedChoiceIndex = _choiceFocusNodes[i].hasFocus ? i : -1;
        });
      });
    }
  }

  void _updateImages(List<XFile> newImages) {
    setState(() {
      _selectedImages.clear();
      _selectedImages.addAll(newImages);
    });
  }

  @override
  void dispose() {
    _introController.dispose();
    for (var controller in _choiceControllers) {
      controller.dispose();
    }
    for (var node in _choiceFocusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        // 선택지를 눌렀을때 appbar의 색상이 변하는
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              context.pop();
            },
          ),
        ),
        body: Stack(
          children: [
            Divider(
              color: Colors.grey,
              thickness: 1,
              height: 1,
            ),
            SafeArea(
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTitleField(controller: _titleController),
                        CustomIntroField(controller: _introController),
                        BubbleWidget(comment: "필요에 따라 설명에 사진을 추가할 수 있어요"),
                        ImagePickerWidget(
                          selectedImages: _selectedImages,
                          onImageSelected: _updateImages,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: _buildChoiceField('첫번째 선택지', 0),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: _buildChoiceField('두번째 선택지', 1),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () async {
                            _submitWorry;
                            router.go('/home');
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black,
                          ),
                          child: Center(child: Text('등록하기')),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitWorry() async {
    FocusScope.of(context).unfocus();
    debugPrint("✅ 제목: ${_titleController.text}");
    debugPrint("✅ 설명: ${_introController.text}");
    debugPrint("✅ 선택지1: ${_choiceControllers[0].text}");
    debugPrint("✅ 선택지2: ${_choiceControllers[1].text}");
    if (_titleController.text.trim().isEmpty ||
        _introController.text.trim().isEmpty ||
        _choiceControllers[0].text.trim().isEmpty ||
        _choiceControllers[1].text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("제목, 설명, 선택지를 모두 입력해주세요.")),
      );
      return;
    }

    try {
      List<MapEntry<String, MultipartFile>> imageFiles = [];
      for (var image in _selectedImages) {
        MultipartFile file =
            await MultipartFile.fromFile(image.path, filename: image.name);
        imageFiles.add(MapEntry("images", file)); // ✅ MapEntry로 변환
      }

      FormData formData = FormData.fromMap({
        "title": _introController.text.trim(), // 제목
        "description": _introController.text.trim(), // 고민 설명
        "option1": _choiceControllers[0].text.trim(), // 첫 번째 선택지
        "option2": _choiceControllers[1].text.trim(), // 두 번째 선택지
      });

      if (imageFiles.isNotEmpty) {
        formData.files.addAll(
          (imageFiles),
        );
      }

      Response response = await _dio.post(
        "$apiUrl/api/post",
        data: formData,
        options: Options(
          headers: {"Content-Type": "multipart/form-data"},
        ),
      );

      debugPrint("✅ 응답 코드: ${response.statusCode}");
      debugPrint("✅ 응답 데이터: ${response.data}");

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("고민글 작성 완료! 🎉")),
        );
        ref.invalidate(postProvider);
        router.go('/home');
        // 입력 필드 초기화
        _clearFields();
      } else {
        throw Exception("고민글 작성 실패: ${response.statusMessage}");
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint("❌ DioException 발생!");
        debugPrint("❌ 요청 URL: $apiUrl/api/post");
        debugPrint("❌ 요청 데이터: ${e.requestOptions.data}");
        debugPrint("❌ 응답 코드: ${e.response?.statusCode}");
        debugPrint("❌ 응답 데이터: ${e.response?.data}");
        debugPrint("❌ DioException 메시지: ${e.message}");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("오류 발생: ${e.toString()}")),
      );
    }
  }

  void _clearFields() {
    setState(() {
      _titleController.clear();
      _introController.clear();
      for (var controller in _choiceControllers) {
        controller.clear();
      }
      _selectedImages.clear();
    });
  }

  Widget _buildChoiceField(String label, int index) {
    return IntrinsicHeight(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              label,
              style: TextStyle(
                color: _focusedChoiceIndex == index
                    ? Color(0xFFFA743E)
                    : Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 5),
          Stack(
            children: [
              TextField(
                controller: _choiceControllers[index],
                focusNode: _choiceFocusNodes[index],
                maxLength: 15,
                onChanged: (text) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  counterText: "", // 기본 counter 숨김
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFA743E), width: 1),
                  ),
                  hintText: '내용을 입력하세요',
                ),
                style: TextStyle(fontSize: 10),
              ),
              Positioned(
                right: 10,
                bottom: 5,
                child: AnimatedOpacity(
                  opacity: _focusedChoiceIndex == index ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 200),
                  child: Text(
                    "${_choiceControllers[index].text.length}/15", // 글자수 표시
                    style: TextStyle(color: Color(0xFFFA743E), fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomTitleField extends StatefulWidget {
  final TextEditingController controller; // 🔥 외부에서 컨트롤러를 받음

  const CustomTitleField({required this.controller, super.key});

  @override
  _CustomTitleFieldState createState() => _CustomTitleFieldState();
}

class _CustomTitleFieldState extends State<CustomTitleField> {
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        TextField(
          focusNode: _focusNode,
          controller: widget.controller, // 🔥 외부에서 받은 컨트롤러 사용
          maxLength: 20,
          decoration: InputDecoration(
            counterStyle: TextStyle(color: Color(0xFFFA743E), fontSize: 12),
            hintText: '제목을 입력하세요',
            hintStyle: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                color: _isFocused ? Color(0xFFFA743E) : Colors.grey,
                width: 2,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
                width: 1,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xFFFA743E),
                width: 2,
              ),
            ),
            counterText: _isFocused ? null : "", // 글자수 제한 표시를 입력 중일 때만
          ),
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold, // 입력 시 볼드 처리
          ),
        ),
      ],
    );
  }
}

class CustomIntroField extends StatefulWidget {
  final TextEditingController controller;

  const CustomIntroField({super.key, required this.controller});

  @override
  State<CustomIntroField> createState() => _CustomIntroFieldState();
}

class _CustomIntroFieldState extends State<CustomIntroField> {
  bool _isFocused = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Stack(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(0),
              ),
              child: TextField(
                focusNode: _focusNode,
                controller: widget.controller,
                maxLines: 4,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(100),
                ],
                onChanged: (text) {
                  setState(() {});
                },
                decoration: InputDecoration(
                  hintText: '100자 이내로 고민에 대해 설명해주세요.\n고민은 당일 24시가 되면 사라집니다.',
                  hintStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  counterText: "",
                ),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 5,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: _isFocused ? 1.0 : 0.0,
                child: Text(
                  "${widget.controller.text.length}/100",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFA743E),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ImagePickerWidget extends StatelessWidget {
  final List<XFile> selectedImages;
  final Function(List<XFile>) onImageSelected;

  ImagePickerWidget(
      {super.key, required this.selectedImages, required this.onImageSelected});

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages(BuildContext context) async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();

      if (images.isEmpty) {
        print("이미지가 선택되지 않음.");
        return;
      }

      List<XFile> validImages = images.where((image) {
        return image.path.isNotEmpty && File(image.path).existsSync();
      }).toList();

      if (selectedImages.length + validImages.length > 4) {
        int spaceLeft = 4 - selectedImages.length;
        onImageSelected([...selectedImages, ...validImages.take(spaceLeft)]);
      } else {
        onImageSelected([...selectedImages, ...validImages]);
      }
    } catch (e) {
      print("이미지 선택 중 오류 발생: $e");
    }
  }

  void _removeImage(int index) {
    List<XFile> updatedList = List.from(selectedImages)..removeAt(index);
    onImageSelected(updatedList);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _pickImages(context),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: const Color.fromARGB(255, 189, 189, 189)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.camera_alt, size: 24, color: Colors.grey),
                Text.rich(TextSpan(children: [
                  TextSpan(
                    text: "${selectedImages.length}",
                    style: TextStyle(
                      color: Color(0xFFFA743E),
                      fontSize: 12,
                    ),
                  ),
                  TextSpan(
                      text: "/4",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      )),
                ])),
              ],
            ),
          ),
        ),
        SizedBox(width: 10),

        // 선택한 이미지 리스트
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: selectedImages.asMap().entries.map((entry) {
                int index = entry.key;
                XFile image = entry.value;
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: File(image.path).existsSync()
                          ? Image.file(
                              File(image.path), // ✅ 경로 정리 후 Image.file 사용
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.error, size: 60),
                            )
                          : Icon(Icons.error,
                              size: 60), // 파일이 존재하지 않으면 에러 아이콘 표시
                    ),
                    GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black54,
                        ),
                        child: Icon(Icons.close, size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
