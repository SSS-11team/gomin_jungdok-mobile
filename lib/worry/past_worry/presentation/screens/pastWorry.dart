import 'package:flutter/material.dart';

class PastWorry extends StatelessWidget {
  const PastWorry({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '과거 고민 등록 페이지',
          style: TextStyle(fontSize: 24, color: Colors.red),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
