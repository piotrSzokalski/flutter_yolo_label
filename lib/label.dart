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

  List<Offset> edges = [];

  late LabelPainter labelPainter;

  _LabelPage(String path) {
    this.imagePath = path;

    loadImage();

    super.initState();
  }

  Future loadImage() async {
    final data = File(imagePath);
    final bytes2 = await data.readAsBytes();

    final image = await decodeImageFromList(bytes2);

    if (image != null) {
      //labelPainter = LabelPainter(image!, edges);
    }

    setState(() => this.image = image);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: image == null
              ? CircularProgressIndicator()
              : GestureDetector(
                  onPanStart: (details) {
                    setState(() {
                      edges.add(details.localPosition);
                      edges.add(details.localPosition);
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      edges[edges.length - 1] = details.localPosition;
                    });
                  },
                  child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    child: FittedBox(
                      child: SizedBox(
                        width: image!.width.toDouble(),
                        height: image!.height.toDouble(),
                        child: CustomPaint(
                          painter: labelPainter =
                              new LabelPainter(image!, edges),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              edges = [];
            });
          },
          child: Text('cls'),
        ),
      );
}

class LabelPainter extends CustomPainter {
  final ui.Image image;
  final List<Offset> edges;

  const LabelPainter(this.image, this.edges);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;

    canvas.drawImage(image, Offset.zero, paint);

    for (int i = 0; i < edges.length - 1; i += 2) {
      canvas.drawRect(Rect.fromPoints(edges[i], edges[i + 1]), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
