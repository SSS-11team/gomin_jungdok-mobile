import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:gomin_jungdok_mobile/common/const/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(milliseconds: 3000), () {
      if (mounted) {
        context.go('/home'); // go_router를 사용한 화면 전환
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: MAIN_COLOR,
        body: Center(
          child: Column(
            children: [
              SizedBox(height: size.width * 0.55),
              SvgPicture.asset(
                'assets/icons/logoTypo.svg',
                height: size.width * 0.5,
                colorFilter:
                    const ColorFilter.mode(MAIN_BG_COLOR, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
