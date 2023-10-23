import 'package:flutter/material.dart';

class ScreenOneMainMenu extends StatelessWidget {
  const ScreenOneMainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(title: const Text('Screen one main menu')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('What would you like to do today?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 20),
              Container(
                height: 100,
                width: width / 2,
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(12)),
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text('Tasks',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18)),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Icon(Icons.playlist_add_check_outlined,
                            color: Colors.white, size: 48),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomMenuIcon extends StatelessWidget {
  const CustomMenuIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _CustomMenuPainter(),
      size: const Size(24, 24),
    );
  }
}

class _CustomMenuPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    const double lineSpacing = 4.0;
    const double lineStartX = 0.0;
    final double lineEndX = size.width;

    const Offset checkmarkOffset = Offset(lineStartX + 2.0, lineSpacing + 2.0);
    final Offset firstLineStart =
        Offset(checkmarkOffset.dx + 6.0, checkmarkOffset.dy);
    final Offset firstLineEnd = Offset(lineEndX, firstLineStart.dy);
    final Offset secondLineStart =
        Offset(lineStartX, firstLineEnd.dy + lineSpacing);
    final Offset secondLineEnd = Offset(lineEndX, secondLineStart.dy);
    final Offset thirdLineStart =
        Offset(lineStartX, secondLineEnd.dy + lineSpacing);
    final Offset thirdLineEnd = Offset(lineEndX, thirdLineStart.dy);

    canvas.drawLine(checkmarkOffset,
        Offset(checkmarkOffset.dx + 4.0, checkmarkOffset.dy + 4.0), paint);
    canvas.drawLine(firstLineStart, firstLineEnd, paint);
    canvas.drawLine(secondLineStart, secondLineEnd, paint);
    canvas.drawLine(thirdLineStart, thirdLineEnd, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
