import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AgreementScreen(),
    );
  }
}

class AgreementScreen extends StatefulWidget {
  @override
  _AgreementScreenState createState() => _AgreementScreenState();
}

class _AgreementScreenState extends State<AgreementScreen> {
  bool allChecked = false;
  bool termsChecked = false;
  bool privacyChecked = false;

  void updateAllChecked(bool? value) {
    setState(() {
      allChecked = value ?? false;
      termsChecked = allChecked;
      privacyChecked = allChecked;
    });
  }

  void updateSingleChecked(bool? value, String type) {
    setState(() {
      if (type == 'terms') {
        termsChecked = value ?? false;
      } else if (type == 'privacy') {
        privacyChecked = value ?? false;
      }
      allChecked = termsChecked && privacyChecked;
    });
  }

  void showTermsModal(BuildContext context, String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Text(
                        content,
                        style: TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: '고민중독',
                    style: TextStyle(
                      color: Color(0xffFA743E),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '에 오신 것을 환영합니다!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              '아래 항목을 확인하고 동의해주세요.\n\n'
              '회원님은 동의를 거부할 수 있지만, 필수 항목을 동의하지 않으면 서비스를 사용할 수 없어요.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Divider(),
            CheckboxListTile(
              title: const Text('전체동의'),
              activeColor: Color(0xffFA743E),
              value: allChecked,
              onChanged: updateAllChecked,
              controlAffinity: ListTileControlAffinity.leading,
            ),
            Divider(),
            ListTile(
              leading: Checkbox(
                activeColor: Color(0xffFA743E),
                value: termsChecked,
                onChanged: (value) => updateSingleChecked(value, 'terms'),
              ),
              title: const Text(
                '필수  서비스 이용약관',
                style: TextStyle(
                    color: Color(0xffFA743E), fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward_ios,
                  size: 18, color: Color(0xffFA743E)),
              onTap: () {
                showTermsModal(
                  context,
                  "서비스 이용약관",
                  "제1조 목적\n\n"
                      "이 약관은 ‘고민중독’(이하 “서비스”)이 제공하는 기능 및 "
                      "이용과 관련하여, 서비스와 회원 간의 권리, 의무 및 책임사항 등을 규정함을 목적으로 합니다.\n\n"
                      "제2조 정의\n"
                      "1. '서비스'란 ‘고민중독’이라는 이름으로 운영되는 모바일 애플리케이션을 의미합니다.\n"
                      "2. '회원'이란 본 약관에 따라 이용계약을 체결하고 서비스를 이용하는 자를 의미합니다.\n"
                      "3. '콘텐츠'란 회원이 서비스 내에서 작성, 등록하는 고민, 댓글, 투표 선택 등을 의미합니다.\n\n"
                      "제3조 약관의 효력 및 변경\n"
                      "1. 본 약관은 회원이 서비스에 최초 회원가입을 하거나 동의 절차를 거치는 경우 효력이 발생합니다.\n"
                      "2. 서비스는 약관을 변경할 수 있으며, 변경 시 최소 7일 전 공지합니다.\n"
                      "3. 회원은 약관을 서비스 이용 시에 수시로 확인 가능합니다.\n"
                      "4. 회원이 변경된 약관에 동의하지 않을 경우, 서비스 이용을 중단하고 탈퇴할 수 있습니다.",
                );
              },
            ),
            ListTile(
              leading: Checkbox(
                activeColor: Color(0xffFA743E),
                value: privacyChecked,
                onChanged: (value) => updateSingleChecked(value, 'privacy'),
              ),
              title: const Text(
                '필수  개인정보 수집 및 이용 동의',
                style: TextStyle(
                    color: Color(0xffFA743E), fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward_ios,
                  size: 18, color: Color(0xffFA743E)),
              onTap: () {
                showTermsModal(
                  context,
                  "개인정보 수집 및 이용 동의",
                  "제1조 개인정보 수집 목적\n\n"
                      "서비스는 회원의 원활한 서비스 이용을 위해 최소한의 개인정보를 수집합니다.\n\n"
                      "제2조 수집하는 개인정보 항목\n"
                      "1. 회원가입 시: 이메일, 이름, 프로필 사진 (선택 사항)\n"
                      "2. 서비스 이용 과정에서: 기기 정보, IP 주소, 쿠키 정보\n\n"
                      "제3조 개인정보 보유 기간\n"
                      "1. 회원 탈퇴 시 즉시 삭제\n"
                      "2. 법령에 의해 보관할 필요가 있는 경우, 관련 법령에 따라 일정 기간 보관",
                );
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffFA743E),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: termsChecked && privacyChecked ? () {} : null,
                child: const Text(
                  '동의하고 시작하기',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
