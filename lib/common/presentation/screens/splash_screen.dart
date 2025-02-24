import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gomin_jungdok_mobile/common/component/colors.dart';
import 'package:gomin_jungdok_mobile/worry_solution/presentation/screens/solutionDetails_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
        const Duration(milliseconds: 3000),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SolutionDetailsView(
                      postId: 1,
                    ))));
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
            SizedBox(
              height: size.width * 0.55,
            ),
            SvgPicture.asset(
              'assets/icons/logoTypo.svg',
              height: size.width * 0.5,
              // color: Colors.white,
              colorFilter:
                  const ColorFilter.mode(MAIN_BG_COLOR, BlendMode.srcIn),
            ),
          ],
        ),
      ),
    ));
  }
}
