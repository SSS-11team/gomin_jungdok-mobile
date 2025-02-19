import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:gomin_jungdok_mobile/worryRegist/tooltip_screen.dart';
import 'package:image_picker/image_picker.dart';

class NormalWorry extends StatefulWidget {
  @override
  _NormalWorryState createState() => _NormalWorryState();
}

class _NormalWorryState extends State<NormalWorry> {
  final TextEditingController _introController = TextEditingController();
  int _introTextLength = 0;
  int _focusedChoiceIndex = -1; // 선택된 선택지 인덱스
  final List<TextEditingController> _choiceControllers = [
    TextEditingController(),
    TextEditingController(),
  ];
  final List<FocusNode> _choiceFocusNodes = [FocusNode(), FocusNode()];

  @override
  void initState() {
    super.initState();
    _introController.addListener(() {
      setState(() {
        _introTextLength = _introController.text.length;
      });
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      // 선택지를 눌렀을때 appbar의 색상이 변하는
      // 오류를 해결하는 extedBody-
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          color: Colors.white, // 🔥 AppBar 배경 고정
          child: SafeArea(
            child: AppBar(
              backgroundColor:
                  Colors.transparent, // 🔥 투명하게 해서 Container 색상을 유지
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  context.go('/');
                },
              ),
            ),
          ),
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
                      CustomTitleField(),
                      CustomIntroField(controller: _introController),
                      BubbleWidget(comment: "필요에 따라 설명에 사진을 추가할 수 있어요"),
                      ImagePickerWidget(),
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
                        onPressed: () {},
                        child: Center(child: Text('등록하기')),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          backgroundColor: Colors.grey.shade300,
                          foregroundColor: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
  @override
  _CustomTitleFieldState createState() => _CustomTitleFieldState();
}

class _CustomTitleFieldState extends State<CustomTitleField> {
  bool _isFocused = false;
  final TextEditingController _controller = TextEditingController();
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
    _controller.dispose();
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
          controller: _controller,
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

  CustomIntroField({required this.controller});

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

class ImagePickerWidget extends StatefulWidget {
  @override
  _ImagePickerWidgetState createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedImages = [];

  // 갤러리에서 이미지 선택
  Future<void> _pickImages() async {
    final List<XFile>? images = await _picker.pickMultiImage();

    if (images != null) {
      setState(() {
        // 최대 4개까지만 추가 가능하도록 제한
        if (_selectedImages.length + images.length <= 4) {
          _selectedImages.addAll(images);
        } else {
          int spaceLeft = 4 - _selectedImages.length;
          _selectedImages.addAll(images.take(spaceLeft));
        }
      });
    }
  }

  // 이미지 삭제
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: _pickImages,
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
                    text: "${_selectedImages.length}",
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
        SizedBox(
          width: 10,
        ),

        // 선택한 이미지 리스트
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _selectedImages.asMap().entries.map((entry) {
                int index = entry.key;
                XFile image = entry.value;
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        image.path,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
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
              spacing: 10,
            ),
          ),
        ),
      ],
    );
  }
}
