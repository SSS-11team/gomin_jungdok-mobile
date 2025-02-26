import 'package:flutter/material.dart';

class MyProfile extends StatelessWidget {
  const MyProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          '마이페이지',
          style: TextStyle(fontSize: 24, color: Colors.red),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
