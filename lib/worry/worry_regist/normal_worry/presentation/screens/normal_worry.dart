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
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class NormalWorry extends ConsumerStatefulWidget {
  const NormalWorry({super.key});

  @override
  _NormalWorryState createState() => _NormalWorryState();
}

class _NormalWorryState extends ConsumerState<NormalWorry> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _introController = TextEditingController();
  String? selectedCategory;
  // int _introTextLength = 0;
  int _focusedChoiceIndex = -1; // 선택된 선택지 인덱스
  final List<TextEditingController> _choiceControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  final List<FocusNode> _choiceFocusNodes = [FocusNode(), FocusNode()];
  List<AssetEntity> _selectedImages = [];
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

  void _updateImages(List<AssetEntity> newImages) {
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
                        SizedBox(
                          height: 20,
                        ),
                        CategorySelector(
                          initialCategory: "친구",
                          onSelected: (category) {
                            selectedCategory = category;
                          },
                        ),
                        CustomIntroField(controller: _introController),
                        BubbleWidget(comment: "필요에 따라 설명에 사진을 추가할 수 있어요"),
                        WeChatImagePickerWidget(
                          selectedImages: _selectedImages,
                          onImageSelected: (newAssets) {
                            setState(() {
                              _selectedImages = newAssets;
                            });
                          },
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
                            await _submitWorry();
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
    debugPrint("✅ 선택된 카테고리: $selectedCategory");
    debugPrint("✅ 설명: ${_introController.text}");
    debugPrint("✅ 선택지1: ${_choiceControllers[0].text}");
    debugPrint("✅ 선택지2: ${_choiceControllers[1].text}");
    if (_titleController.text.trim().isEmpty ||
        _introController.text.trim().isEmpty ||
        _choiceControllers[0].text.trim().isEmpty ||
        _choiceControllers[1].text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("제목, 카테고리, 설명, 선택지를 모두 입력해주세요.")),
      );
      return;
    }

    try {
      List<MapEntry<String, MultipartFile>> imageFiles = [];

      for (var asset in _selectedImages) {
        final file = await asset.file;
        final name = await asset.titleAsync;

        if (file != null) {
          MultipartFile multipartFile = await MultipartFile.fromFile(
            file.path,
            filename: name ?? 'image.jpg',
          );
          imageFiles.add(MapEntry("images", multipartFile));
        }
      }

      FormData formData = FormData.fromMap({
        "title": _titleController.text.trim(), // 제목
        "category": selectedCategory, // 카테고리
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
    } catch (e, stack) {
      debugPrint("❌ 예외 발생: $e");
      debugPrint("❌ 스택트레이스: $stack");

      if (e is DioException) {
        debugPrint("❌ DioException 발생!");
        debugPrint("❌ 요청 URL: ${e.requestOptions.uri}");
        debugPrint("❌ 요청 데이터: ${e.requestOptions.data}");
        debugPrint("❌ 응답 코드: ${e.response?.statusCode}");
        debugPrint("❌ 응답 데이터: ${e.response?.data}");
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

class CategorySelector extends StatefulWidget {
  final String? initialCategory;
  final Function(String) onSelected;

  const CategorySelector({
    super.key,
    this.initialCategory,
    required this.onSelected,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final categories = ["일상", "연애", "진로", "인간관계", "사회생활", "기타"];
  String? selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40, // 높이 고정해서 한 줄로 유지
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selected == category;

          return ChoiceChip(
            label: Text(
              category,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            selected: isSelected,
            onSelected: (bool selectedNow) {
              setState(() {
                selected = category;
              });
              widget.onSelected(category);
            },
            selectedColor: const Color(0xFFFA743E),
            backgroundColor: Colors.grey.shade200,
            showCheckmark: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          );
        },
      ),
    );
  }
}

class WeChatImagePickerWidget extends StatelessWidget {
  final List<AssetEntity> selectedImages;
  final Function(List<AssetEntity>) onImageSelected;

  const WeChatImagePickerWidget({
    super.key,
    required this.selectedImages,
    required this.onImageSelected,
  });

  Future<void> _pickImages(BuildContext context) async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        maxAssets: 4,
        selectedAssets: selectedImages,
        requestType: RequestType.image,
      ),
    );

    if (assets != null && assets.isNotEmpty) {
      onImageSelected(assets);
    }
  }

  void _removeImage(int index) {
    final updated = List<AssetEntity>.from(selectedImages)..removeAt(index);
    onImageSelected(updated);
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
                const Icon(Icons.camera_alt, size: 24, color: Colors.grey),
                Text.rich(TextSpan(children: [
                  TextSpan(
                    text: "${selectedImages.length}",
                    style:
                        const TextStyle(color: Color(0xFFFA743E), fontSize: 12),
                  ),
                  const TextSpan(
                    text: "/4",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ])),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: selectedImages.asMap().entries.map((entry) {
                final index = entry.key;
                final asset = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: FutureBuilder<File?>(
                    future: asset.file,
                    builder: (context, snapshot) {
                      final file = snapshot.data;
                      if (file == null) {
                        return const Icon(Icons.image_not_supported, size: 60);
                      }

                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              file,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _removeImage(index),
                            child: Container(
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black54,
                              ),
                              child: const Icon(Icons.close,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
