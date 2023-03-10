import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:document_file_save_plus/document_file_save_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'class_names.dart';
import 'utlis.dart';

import 'global_state.dart';

class LabelPage extends StatefulWidget {
  XFile image;
  LabelPage(this.image);

  @override
  State<StatefulWidget> createState() => _LabelPage(image);
}

class _LabelPage extends State {
  XFile xImage;

  ui.Image? image;

  List<Offset> edges = [];

  late LabelPainter labelPainter;

  _LabelPage(this.xImage) {
    loadImage();

    super.initState();
  }

  Future loadImage() async {
    final data = File(xImage.path);
    final bytes2 = await data.readAsBytes();

    final image = await decodeImageFromList(bytes2);

    print(xImage.path);

    if (image != null) {
      //labelPainter = LabelPainter(image!, edges);
    }

    setState(() => this.image = image);
  }

  void save(BuildContext context) async {
    DocumentFileSavePlus.saveMultipleFiles([
      await xImage.readAsBytes(),
      GlobalState.generateBoundingBoxesFile(),
      GlobalState.generateClassNamesFile()
    ], [
      Utilities.generateFileName('jpg'),
      Utilities.generateFileName('txt'),
      'classes.txt'
    ], [
      'image/jpg',
      "text/plain",
      "text/plain"
    ]);

    GlobalState.clearRecords();
    Navigator.pop(context);
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
                onPanEnd: (details) {
                  GlobalState.addRecordBoundaries(
                      edges[edges.length - 2], edges[edges.length - 1]);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClassNamesPage(() {
                                setState(() {
                                  edges.removeLast();
                                  edges.removeLast();
                                });
                                print(edges);
                              })));
                },
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: FittedBox(
                    child: SizedBox(
                      width: image!.width.toDouble(),
                      height: image!.height.toDouble(),
                      child: CustomPaint(
                        painter: labelPainter = new LabelPainter(image!, edges),
                      ),
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back)),
          FloatingActionButton(
            onPressed: () => save(context),
            child: Icon(Icons.save),
          ),
        ],
      ));
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
