import 'package:flutter/material.dart';

class BubbleWidget extends StatefulWidget {
  final String comment;
  final Color backgroundColor;
  final Color textColor;

  const BubbleWidget({
    Key? key,
    required this.comment,
    this.backgroundColor = const Color(0xFFFA743E),
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  _BubbleWidgetState createState() => _BubbleWidgetState();
}

class _BubbleWidgetState extends State<BubbleWidget> {
  bool _isVisible = true; // 🔥 말풍선 표시 여부

  void hideTooltip() {
    setState(() {
      _isVisible = false; // 🔥 말풍선을 사라지게 변경
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque, // 🔥 터치 이벤트가 빈 공간에서도 감지되도록 설정
      onTap: hideTooltip, // 🔥 아무 곳이나 누르면 사라짐
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300), // 🔥 부드럽게 사라지도록 설정
        child: _isVisible
            ? CustomPaint(
                key: ValueKey<bool>(
                    _isVisible), // 🔥 AnimatedSwitcher가 변화를 감지하도록 설정
                painter: BubblePainter(widget.backgroundColor),
                child: Container(
                  width: 238,
                  height: 40,
                  padding:
                      EdgeInsets.only(left: 12, right: 12, top: 7, bottom: 15),
                  child: Text(
                    widget.comment,
                    style: TextStyle(
                      color: widget.textColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              )
            : SizedBox(height: 40), // 🔥 말풍선 크기만큼 유지하여 UI 밀림 방지
      ),
    );
  }
}

// ✅ 말풍선 + 화살표 CustomPainter (UI 확정)
class BubblePainter extends CustomPainter {
  final Color color;
  BubblePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = color;
    double radius = 8.0;
    double arrowWidth = 10.0;
    double arrowHeight = 10.0;

    Path path = Path()
      ..moveTo(radius, 0)
      ..lineTo(size.width - radius, 0)
      ..quadraticBezierTo(size.width, 0, size.width, radius)
      ..lineTo(size.width, size.height - radius - arrowHeight)
      ..quadraticBezierTo(size.width, size.height - arrowHeight,
          size.width - radius, size.height - arrowHeight)
      ..lineTo(23 + radius, size.height - arrowHeight)
      ..lineTo(20 + arrowWidth / 2, size.height)
      ..lineTo(24 - arrowWidth / 2, size.height - arrowHeight)
      ..lineTo(radius, size.height - arrowHeight)
      ..quadraticBezierTo(
          0, size.height - arrowHeight, 0, size.height - radius - arrowHeight)
      ..lineTo(0, radius)
      ..quadraticBezierTo(0, 0, radius, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
