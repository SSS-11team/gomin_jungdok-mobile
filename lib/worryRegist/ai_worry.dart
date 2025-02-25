import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AiWorry extends StatefulWidget {
  const AiWorry({super.key});

  @override
  _AiWorryState createState() => _AiWorryState();
}

class _AiWorryState extends State<AiWorry> {
  File? _selectedImage; // 선택한 이미지 파일

  // 📌 이미지 선택 함수 (카메라 or 갤러리)
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
    Navigator.pop(context); // 모달 닫기
  }

  // 📌 사진 추가 모달 (카메라 or 갤러리 선택)
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("카메라로 찍기"),
                onTap: () => _pickImage(ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("갤러리에서 선택"),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
            ],
          ),
        );
      },
    );
  }

  // 📌 분석 시작 (AiAnalyze로 이미지 전달)
  void _startAnalysis() {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("사진을 추가해주세요!")),
      );
      return;
    }

    context.push('/aiWorry_analyze', extra: _selectedImage); // ✅ 이미지 전달
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.go('/aiWorry_analyze', extra: _selectedImage);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _showImagePickerOptions,
            child: Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: _selectedImage == null
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined,
                              size: 40, color: Colors.grey),
                          SizedBox(height: 10),
                          Text("사진 추가하기",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16)),
                        ],
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.file(
                        _selectedImage!,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),

          const Spacer(),

          // 분석 시작하기 버튼
          Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Center(
              child: SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: _startAnalysis, // ✅ AI 분석 페이지로 이동 (이미지 전달)
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedImage == null
                        ? Colors.grey.shade300
                        : Color(0xFFFA743E),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('분석 시작하기'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
