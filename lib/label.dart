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
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: image == null
              ? CircularProgressIndicator()
              : GestureDetector(
                  onPanStart: (details) {
                    edges.add(details.localPosition);
                    edges.add(details.localPosition);
                  },
                  onPanUpdate: (details) =>
                      edges[edges.length - 1] = details.localPosition,
                  //onPanEnd:(details) => edges.add(Point(details..dx, details.localPosition.dy)),
                  onPanEnd: (details) {
                    print(edges.toString());
                    setState(() {
                      edges;
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
                          painter: LabelPainter(image!, edges),
                        ),
                      ),
                    ),
                  ),
                ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Text('abc'),
        ),
      );
}

class LabelPainter extends CustomPainter {
  final ui.Image image;
  final List<Offset> edges;

  const LabelPainter(this.image, this.edges);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 10;

    canvas.drawImage(image, Offset.zero, paint);

    canvas.drawLine(edges[0], edges[1], paint);

    // canvas.drawLine(Offset(size.width * 1 / 6, size.height * 1 / 6),
    //     Offset(size.width * 5 / 6, size.height * 5 / 6), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
