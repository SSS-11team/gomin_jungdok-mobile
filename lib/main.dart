import 'package:flutter/material.dart';
import 'package:gomin_jungdok_mobile/worryRegist/mainView.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '고민중독',
      theme: ThemeData(),
      home: const Mainview(),
    );
  }
}
