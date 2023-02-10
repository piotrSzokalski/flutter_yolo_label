import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LabelPage extends StatefulWidget {
  String imagePath = '';
  LabelPage(this.imagePath);

  @override
  State<StatefulWidget> createState() => _LabelPage(imagePath);
}

class _LabelPage extends State {
  String imagePath = '';

  ui.Image? image;

  _LabelPage(String path) {
    this.imagePath = path;

    loadImage();

    super.initState();
  }

  Future loadImage() async {
    final data = File(imagePath);
    final bytes2 = await data.readAsBytes();

    final image = await decodeImageFromList(bytes2);

    setState(() => this.image = image);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              height: 100,
              width: 100,
              child: (image != null
                  ? CustomPaint(
                      foregroundPainter: LabelPainter(image!),
                    )
                  : Text("cos")))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text('abc'),
      ),
    );
  }
}

class LabelPainter extends CustomPainter {
  final ui.Image image;

  const LabelPainter(this.image);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 10;

    canvas.drawImage(image, Offset.zero, paint);

    canvas.drawLine(Offset(size.width * 1 / 6, size.height * 1 / 6),
        Offset(size.width * 5 / 6, size.height * 5 / 6), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
