import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_object_detection/google_mlkit_object_detection.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraResult extends StatefulWidget {
  final String image;
  const CameraResult({super.key, required this.image});

  @override
  State<CameraResult> createState() => _CameraResultState();
}

class _CameraResultState extends State<CameraResult> {
  int _counter = 0;
  final _images = <String>[];
  // ImageLabeler? _imageLabeler;
  ObjectDetector? _objectDetector;
  final _modelPath = 'assets/ml/new_model_metadata.tflite';

  @override
  void initState() {
    _getAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('BMAS Glasses Detection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FutureBuilder<List<DetectedObject>>(
              future: _detectObject(_images[_counter]),
              builder: (context, snapshot) {
                final detectedObjects = snapshot.data ?? [];
                var str = '';

                if (detectedObjects.isNotEmpty) {
                  str = 'Pakai Kacamata';
                } else {
                  str = 'Tidak Ada Kacamata';
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(str),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _getAssets() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final assets = manifestMap.keys
        .where((String key) => key.contains('images/'))
        .where((String key) =>
            key.contains('.jpg') ||
            key.contains('.jpeg') ||
            key.contains('.png') ||
            key.contains('.webp'))
        .toList();
    setState(() {
      _images.clear();
      _images.addAll(assets);
    });
  }

  Future<List<DetectedObject>> _detectObject(String asset) async {
    if (_objectDetector == null) {
      // initialize object detector
      final modelPath = await _getAssetPath(_modelPath);
      final options = LocalObjectDetectorOptions(
        modelPath: modelPath,
        mode: DetectionMode.single,
        classifyObjects: true,
        multipleObjects: true,
      );
      _objectDetector = ObjectDetector(options: options);
    }
    // get and process image
    final inputImage = InputImage.fromFilePath(widget.image);
    return (await _objectDetector?.processImage(inputImage)) ?? [];
  }

  Future<String> _getAssetPath(String asset) async {
    final path = '${(await getApplicationSupportDirectory()).path}/$asset';
    await Directory(dirname(path)).create(recursive: true);
    final file = File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(asset);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }
}
