import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ClockWheel extends StatefulWidget {
  final Duration remainingTime;
  final Duration totalTime;
  final DateTime currentTime;

  const ClockWheel({
    required this.remainingTime,
    required this.totalTime,
    required this.currentTime,
  });

  @override
  _ClockWheelState createState() => _ClockWheelState();
}

class _ClockWheelState extends State<ClockWheel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350, // Keeping the larger size
      height: 350, // Keeping the larger size
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: ClockPainter(
              currentTime: widget.currentTime,
              remainingDays: widget.remainingTime.inDays,
            ),
          ),
          // Center dot
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    ).animate().scale(duration: 600.ms, curve: Curves.easeInOut);
  }
}

class ClockPainter extends CustomPainter {
  final DateTime currentTime;
  final int remainingDays;

  ClockPainter({required this.currentTime, required this.remainingDays});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw clock face with gradient
    final facePaint = Paint()
      ..shader = LinearGradient(
        colors: [Color(0xFF9B00FF), Color(0xFFFF00E5)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, facePaint);

    // Draw clock border
    final borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius - 10, borderPaint);

    // Draw hour marks and numbers
    final markPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4;
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    for (int i = 0; i < 12; i++) {
      // Adjusted angle to start at 12 o'clock and rotate clockwise
      final angle = 2 * math.pi * (i / 12) + math.pi / 2;
      // Move marks inward to increase distance from numbers
      final innerX = center.dx + (radius - 50) * math.cos(angle); // Increased distance
      final innerY = center.dy + (radius - 50) * math.sin(angle);
      final outerX = center.dx + (radius - 35) * math.cos(angle); // Increased distance
      final outerY = center.dy + (radius - 35) * math.sin(angle);
      canvas.drawLine(Offset(innerX, innerY), Offset(outerX, outerY), markPaint);

      // Add hour numbers with increased distance from marks
      final number = (i == 0) ? 12 : i;
      textPainter.text = TextSpan(
        text: number.toString(),
        style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
      );
      textPainter.layout();
      final numberX = center.dx + (radius - 140) * math.cos(angle) - textPainter.width / 2; // Increased distance
      final numberY = center.dy + (radius - 140) * math.sin(angle) - textPainter.height / 2;
      textPainter.paint(canvas, Offset(numberX, numberY));
    }

    // Calculate angles for hands
    final hour = currentTime.hour % 12;
    final minute = currentTime.minute;
    final second = currentTime.second;

    // Adjusted angles for hands to match the corrected orientation
    final hourAngle = 2 * math.pi * ((hour + minute / 60) / 12) + math.pi / 2;
    final minuteAngle = 2 * math.pi * (minute / 60) + math.pi / 2;
    final secondAngle = 2 * math.pi * (second / 60) + math.pi / 2;

    // Draw hour hand
    final hourHandPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final hourHandX = center.dx + (radius - 70) * math.cos(hourAngle);
    final hourHandY = center.dy + (radius - 70) * math.sin(hourAngle);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandPaint);

    // Draw minute hand
    final minuteHandPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    final minuteHandX = center.dx + (radius - 60) * math.cos(minuteAngle);
    final minuteHandY = center.dy + (radius - 60) * math.sin(minuteAngle);
    canvas.drawLine(center, Offset(minuteHandX, minuteHandY), minuteHandPaint);

    // Draw second hand
    final secondHandPaint = Paint()
      ..color = Colors.cyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final secondHandX = center.dx + (radius - 50) * math.cos(secondAngle);
    final secondHandY = center.dy + (radius - 50) * math.sin(secondAngle);
    canvas.drawLine(center, Offset(secondHandX, secondHandY), secondHandPaint);

  }

  @override
  bool shouldRepaint(covariant ClockPainter oldDelegate) {
    return oldDelegate.currentTime != currentTime || oldDelegate.remainingDays != remainingDays;
  }
}