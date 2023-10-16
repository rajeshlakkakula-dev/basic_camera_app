import 'dart:io';

import 'package:camera/camera.dart';

import 'package:flutter/material.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera; //camera.first

  @override
  State<TakePictureScreen> createState() => TakePictureScreenState();

  TakePictureScreen({
    super.key,
    required this.camera,
  });
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initControllerFuture;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Picture'),
      ),
      body: FutureBuilder<void>(
        future: _initControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initControllerFuture;

            final image = await _controller.takePicture();

            if (!mounted) return;

            await Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                      imagePath: image.path,
                    )));
          } catch (e) {
            print(e);
          }
        },
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child:  Image.file(File(imagePath),)
     ),
    );
  }
}
