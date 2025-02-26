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

  Future<void> _startAnalysis() async {
    // 1. 분석 중 모달 표시
    showDialog(
      context: context,
      barrierDismissible: false, // 바깥 터치로 닫기 방지
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "AI가 이미지를 분석 중입니다",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "조금만 기다리면 AI가 고민 제목을 추천해줍니다",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                if (_selectedImage != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.file(
                      _selectedImage!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(),
              ],
            ),
          ),
        );
      },
    );

    // 2. 2초 동안 대기
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return; // 🔥 context가 유효한지 체크

    // 3. 팝업 강제 닫기
    Navigator.of(context, rootNavigator: true).pop(); // ✅ 팝업 닫기

    // 4. 팝업이 완전히 닫히도록 300ms 추가 대기
    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return; // 🔥 context가 다시 유효한지 체크

    // 5. 페이지 이동
    context.go('/aiWorryAnalyze'); // 🚀 AiAnalyze 페이지로 이동
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 배경 흰색
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          color: Colors.white, // AppBar 배경 고정
          child: SafeArea(
            child: AppBar(
              backgroundColor: Colors.transparent, // 투명 처리
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
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10),

                    // 📌 사진 추가 영역 (이미지 선택 후 표시)
                    GestureDetector(
                      onTap: _showImagePickerOptions, // 박스를 누르면 모달 열림
                      child: Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey), // 회색 테두리
                          borderRadius: BorderRadius.circular(5), // 모서리 둥글게
                          color: Colors.white, // 박스 배경 흰색
                        ),
                        child: _selectedImage == null
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 40,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(height: 10),
                                    const Text(
                                      "사진 추가하기",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ],
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.file(
                                  _selectedImage!,
                                  width: double.infinity,
                                  height: 250,
                                  fit: BoxFit.cover, // 사진 크기 맞추기
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// 버튼을 화면 하단 중앙에 배치
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30), // 하단 여백 추가
              child: SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: _selectedImage != null
                      ? () => _startAnalysis() // ✅ 버튼을 누르면 _startAnalysis 실행
                      : () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("사진을 추가해주세요!")),
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    backgroundColor: _selectedImage == null
                        ? Colors.grey.shade300 // ❌ 사진 없을 때 회색 버튼
                        : Color(0xFFFA743E), // ✅ 사진 있을 때 주황색 버튼
                    foregroundColor:
                        _selectedImage == null ? Colors.black : Colors.white,
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
