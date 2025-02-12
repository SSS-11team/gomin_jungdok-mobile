import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class NormalWorry extends StatefulWidget {
  @override
  _NormalWorryState createState() => _NormalWorryState();
}

class _NormalWorryState extends State<NormalWorry> {
  final TextEditingController _introController = TextEditingController();
  int _introTextLength = 0;

  @override
  void initState() {
    super.initState();
    _introController.addListener(() {
      setState(() {
        _introTextLength = _introController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _introController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('일반 고민 작성'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.go('/');
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        // 화면 터치 시 키보드 숨기기
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTitleField(),
                Divider(
                  thickness: 1,
                  color: Colors.grey,
                ),
                CustomIntroField(controller: _introController),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0.0),
                  child: Text(
                    '${_introTextLength}/100자',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildChoiceField('첫번째 선택지'),
                    ),
                    SizedBox(width: 10),
                    Expanded(child: _buildChoiceField('두번째 선택지')),
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
    );
  }

  Widget _buildChoiceField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: Text(label, style: TextStyle(color: Colors.grey))),
        SizedBox(height: 5),
        TextField(
          maxLength: 15,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1),
            ),
            hintText: '내용을 입력하세요',
          ),
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}

class CustomTitleField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(0),
          ),
          child: TextField(
            maxLength: 20,
            decoration: const InputDecoration(
              hintText: '제목을 입력하세요',
              hintStyle: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}

class CustomIntroField extends StatelessWidget {
  final TextEditingController controller;

  CustomIntroField({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(0),
          ),
          child: TextField(
            controller: controller,
            maxLines: 4,
            inputFormatters: [
              LengthLimitingTextInputFormatter(100),
            ],
            decoration: const InputDecoration(
              hintText: '설명을 입력하세요',
              hintStyle: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
