import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gomin_jungdok_mobile/common/const/apiUrl.dart';

class AiAnalyze extends StatefulWidget {
  final File selectedImage; // ✅ 전달받은 이미지

  const AiAnalyze({super.key, required this.selectedImage});

  @override
  _AiAnalyzeState createState() => _AiAnalyzeState();
}

class _AiAnalyzeState extends State<AiAnalyze> {
  int? _selectedTitleIndex;
  List<String> _recommendedTitles = ["AI 분석을 진행해주세요", "", ""];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _analyzeImage(); // ✅ 페이지 열리자마자 AI 분석 실행
  }

  // AI 분석 요청 (이미지를 서버로 전송)
  Future<void> _analyzeImage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(widget.selectedImage.path),
      });

      Response response = await dio.post(
        "$apiURL/api/tensorFlowModel",
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );

      if (response.statusCode == 200 && response.data != null) {
        List<String> fetchedTitles = List<String>.from(
            response.data["message"]); // ✅ "message" 키에서 값 가져오기

        setState(() {
          _recommendedTitles = fetchedTitles.isNotEmpty
              ? fetchedTitles
              : ["추천 제목 없음", "추천 제목 없음", "추천 제목 없음"];
        });
      } else {
        throw Exception("AI 추천 제목 불러오기 실패");
      }
    } catch (e) {
      setState(() {
        _recommendedTitles = ["불러오기 실패", "불러오기 실패", "불러오기 실패"];
      });
      print("❌ AI 추천 제목 불러오기 오류: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
            context.go('/aiWorry');
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: widget.selectedImage != null
                ? Image.file(widget.selectedImage,
                    width: 150, height: 150, fit: BoxFit.cover)
                : const Text("선택된 이미지 없음"),
          ),

          const SizedBox(height: 20),

          // AI 분석 버튼
          Center(
            child: ElevatedButton(
              onPressed: _isLoading ? null : _analyzeImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFA743E),
                foregroundColor: Colors.white,
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("AI 분석 다시 실행"),
            ),
          ),

          const SizedBox(height: 40),

          // AI 추천 제목 리스트
          Column(
            children: List.generate(3, (index) {
              final bool isSelected = _selectedTitleIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedTitleIndex = index;
                  });
                },
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFFFF0EB)
                        : Colors.transparent,
                    border: const Border(
                        bottom: BorderSide(color: Colors.grey, width: 1)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 20),
                    child: Text(
                      _recommendedTitles[index],
                      style: TextStyle(
                          fontSize: 20,
                          color: isSelected
                              ? const Color(0xFFFA743E)
                              : Colors.black),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
