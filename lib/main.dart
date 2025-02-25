import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: DashedOvalProgressBar(
              width: MediaQuery.of(context).size.width / 1.1,
              height: MediaQuery.of(context).size.width * 0.35,
              progress: 10, // 60% progress
              foregroundColor: Colors.blue,
              backgroundColor: Colors.blue.shade100,
            ),
          ),
        ),
      ),
    );
  }
}

class DashedOvalProgressBar extends StatelessWidget {
  final double width;
  final double height;
  final double progress;
  final Color foregroundColor;
  final Color backgroundColor;

  const DashedOvalProgressBar({
    super.key,
    required this.width,
    required this.height,
    required this.progress,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomPaint(
            size: Size(width, height),
            painter: OvalDashedPainter(
              progress: progress,
              foregroundColor: foregroundColor,
              backgroundColor: backgroundColor,
            ),
          ),
        ),
        Positioned(
          top: height * 0.5,
          child: RichText(
            text: TextSpan(
              text: 'Remaining Ifter\n',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              children: [
                TextSpan(
                  text: ' 03:30:00',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class OvalDashedPainter extends CustomPainter {
  final double progress;
  final Color foregroundColor;
  final Color backgroundColor;

  OvalDashedPainter({
    required this.progress,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Rect ovalRect = Rect.fromLTWH(0, 0, size.width, size.height / 0.55);
    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    drawDashedArc(canvas, ovalRect, pi, pi, backgroundPaint);

    Paint dashedPaint = Paint()
      ..color = foregroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    // Draw the dashed arc for progress
    drawDashedArc(canvas, ovalRect, pi, pi * (progress / 100), dashedPaint);

    // Draw sun at the end of the progress
    drawSunAtEndOfProgress(canvas, ovalRect, pi, pi * (progress / 100));
  }

  void drawDashedArc(Canvas canvas, Rect rect, double startAngle,
      double sweepAngle, Paint paint) {
    int dashCount = 60;
    double dashWidth = sweepAngle / dashCount;
    for (int i = 0; i < dashCount; i += 2) {
      canvas.drawArc(
          rect, startAngle + (i * dashWidth), dashWidth, false, paint);
    }
  }

  void drawSunAtEndOfProgress(
      Canvas canvas, Rect rect, double startAngle, double sweepAngle) {
    if (progress <= 0) return;

    // Calculate the end point of the progress arc
    final endAngle = startAngle + sweepAngle;
    final centerX = rect.center.dx;
    final centerY = rect.center.dy;
    final radiusX = rect.width / 2;
    final radiusY = rect.height / 2;

    // Get the position on the oval at the end angle
    final x = centerX + radiusX * cos(endAngle);
    final y = centerY + radiusY * sin(endAngle);

    // Draw white circle background
    final circlePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(x, y), 15, circlePaint);

    // Draw the sun icon manually
    final sunPaint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;

    // Draw sun center
    canvas.drawCircle(Offset(x, y), 6, sunPaint);

    // Draw sun rays
    final rayPaint = Paint()
      // ignore: deprecated_member_use
      ..color = Colors.blueAccent.withOpacity(0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw 8 rays around the sun
    for (int i = 0; i < 8; i++) {
      final rayAngle = i * pi / 4;
      final rayStartX = x + 8 * cos(rayAngle);
      final rayStartY = y + 8 * sin(rayAngle);
      final rayEndX = x + 14 * cos(rayAngle);
      final rayEndY = y + 14 * sin(rayAngle);

      canvas.drawLine(
          Offset(rayStartX, rayStartY), Offset(rayEndX, rayEndY), rayPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
