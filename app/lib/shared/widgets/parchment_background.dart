import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/theme_provider.dart';

class ParchmentBackground extends StatelessWidget {
  final Widget child;

  const ParchmentBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        // Only apply texture in Parchment mode
        if (!themeProvider.isParchmentMode) {
          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: child,
          );
        }

        return Stack(
          children: [
            // Base color
            Container(color: const Color(0xFFF5F0E6)),

            // Procedural Noise Texture (Fallback if image missing)
            Positioned.fill(
              child: CustomPaint(
                painter: _PaperGrainPainter(),
              ),
            ),

            // Content
            child,
          ],
        );
      },
    );
  }
}

class _PaperGrainPainter extends CustomPainter {
  final Random _random = Random(42); // Fixed seed for consistent texture

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Draw subtle noise
    for (int i = 0; i < size.width * size.height / 400; i++) {
      final x = _random.nextDouble() * size.width;
      final y = _random.nextDouble() * size.height;

      // Warm noise
      paint.color = Color.fromARGB(
        10 + _random.nextInt(10), // Very low alpha
        160 + _random.nextInt(40), // R: warm
        140 + _random.nextInt(40), // G: warm
        120 + _random.nextInt(30), // B: warm
      );

      canvas.drawCircle(Offset(x, y), 0.5 + _random.nextDouble(), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
