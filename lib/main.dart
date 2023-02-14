import 'package:flutter/material.dart';

import 'dart:io';

import 'package:camera/camera.dart';

import 'label.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String imagePath = '';
  late List<CameraDescription> _cameras;
  late CameraController _cameraController;

  late XFile _image;

  void _takePicture() async {
    try {
      _image = await _cameraController.takePicture();
      setState(() {
        imagePath = _image.path;
        print(imagePath);
      });
    } catch (e) {
      print(e);
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LabelPage(_image)));
  }

  void startCamera() async {
    _cameras = await availableCameras();
    _cameraController = await CameraController(
        _cameras[0], ResolutionPreset.high,
        enableAudio: false);
    await _cameraController.initialize();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    startCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            Stack(children: [
              (_cameraController.value.isInitialized
                  ? CameraPreview(_cameraController)
                  : Text('brak kamery'))
            ]),

            //Image.file(File(imagePath))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _takePicture,
          tooltip: 'take_picture',
          child: const Icon(Icons.add_a_photo),
        ),
      );
}
