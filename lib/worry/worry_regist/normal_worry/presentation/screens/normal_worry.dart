import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gomin_jungdok_mobile/common/const/api.dart';
import 'package:gomin_jungdok_mobile/common/presentation/router/go_router.dart';
import 'package:gomin_jungdok_mobile/worry/worry_regist/component/widgets/tooltip_screen.dart';
import 'package:gomin_jungdok_mobile/worry/worry_regist/normal_worry/presentation/widgets/customTitleField.dart';
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
  int _focusedChoiceIndex = -1;

  final List<TextEditingController> _choiceControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  final List<FocusNode> _choiceFocusNodes = [FocusNode(), FocusNode()];
  final List<XFile> _selectedImages = [];

  final Dio _dio = Dio(
    BaseOptions(
    connectTimeout: const Duration(seconds: 10),  // 서버 연결 제한 시간
    receiveTimeout: const Duration(seconds: 15),  // 응답 수신 제한 시간
    sendTimeout: const Duration(seconds: 10),     // 데이터 업로드 제한 시간
    contentType: 'multipart/form-data',           // (선택) 기본 contentType 설정도 가능
  ),
  );
  static const String apiUrl = BASE_URL;

  @override
  void initState() {
    super.initState();
    _introController.addListener(() => setState(() {}));

    for (var i = 0; i < _choiceControllers.length; i++) {
      _choiceControllers[i].addListener(() => setState(() {}));
      _choiceFocusNodes[i].addListener(() {
        setState(() {
          _focusedChoiceIndex = _choiceFocusNodes[i].hasFocus ? i : -1;
        });
      });
    }
  }

  void _updateImages(List<XFile> newImages) {
    if (_selectedImages.length + newImages.length > 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("최대 4장의 이미지만 업로드할 수 있습니다.")),
      );
      return;
    }

    setState(() {
      _selectedImages.addAll(newImages.take(4 - _selectedImages.length));
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
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
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => context.pop(),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTitleField(controller: _titleController),
                CustomIntroField(controller: _introController),
                const BubbleWidget(comment: "필요에 따라 설명에 사진을 추가할 수 있어요"),
                ImagePickerWidget(
                  selectedImages: _selectedImages,
                  onImageSelected: _updateImages,
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(child: _buildChoiceField('첫번째 선택지', 0)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildChoiceField('두번째 선택지', 1)),
                  ],
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    //print("✅ 버튼 눌림!");
                    await _submitWorry();
                    router.go('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.black,
                  ),
                  child: const Center(child: Text('등록하기')),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitWorry() async {
    FocusScope.of(context).unfocus();

    print("📝 _submitWorry 실행됨");

    if (_titleController.text.trim().isEmpty ||
        _introController.text.trim().isEmpty ||
        _choiceControllers[0].text.trim().isEmpty ||
        _choiceControllers[1].text.trim().isEmpty) {
      print("❗️필수 입력값 누락됨");

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("제목, 설명, 선택지를 모두 입력해주세요.")),
      );
      return;
    }

    try {
      List<MapEntry<String, MultipartFile>> imageFiles = [];
      for (var image in _selectedImages) {
        MultipartFile file =
            await MultipartFile.fromFile(image.path, filename: image.name);
        imageFiles.add(MapEntry("images", file));
      }

      FormData formData = FormData.fromMap({
        "title": _titleController.text.trim(),
        "description": _introController.text.trim(),
        "option1": _choiceControllers[0].text.trim(),
        "option2": _choiceControllers[1].text.trim(),
      });

      if (imageFiles.isNotEmpty) {
        formData.files.addAll(imageFiles);
      }

      Response response = await _dio.post(
        "$apiUrl/api/post",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      if (response.statusCode == 201) {
        print("🎉 등록 성공 → 페이지 이동 시작");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("고민글 작성 완료! 🎉")),
        );
        ref.invalidate(postProvider);
        router.go('/home');
        _clearFields();
      } else {
        throw Exception("고민글 작성 실패: ${response.statusMessage}");
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint("❌ DioException 발생!");
        debugPrint("❌ 요청 URL: $apiUrl/api/post");
        debugPrint("❌ 요청 데이터: ${e.requestOptions.data ?? "데이터 없음"}");
        debugPrint("❌ 응답 코드: ${e.response?.statusCode}");
        debugPrint("❌ 응답 데이터: ${e.response?.data}");
        debugPrint("❌ DioException 메시지: ${e.message}");
      }

      if (!mounted) return;

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
      return Column(
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
                      EdgeInsets.symmetric(vertical: 16, horizontal: 10),
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
      );
  }
}
