import 'dart:io';

import 'package:flutter/material.dart';

class LabelPage extends StatefulWidget {
  String imagePath = '';
  LabelPage(this.imagePath);

  @override
  State<StatefulWidget> createState() => _LabelPage(imagePath);
}

class _LabelPage extends State {
  String imagePath = '';

  _LabelPage(this.imagePath);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        (File(imagePath).existsSync()
            ? Image.file(File(imagePath))
            : Text('brak zdjecia'))
      ]),
    );
  }
}
