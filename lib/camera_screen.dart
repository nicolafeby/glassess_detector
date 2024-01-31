import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:glassess_detector/camera_result.dart';
import 'package:glassess_detector/main.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  FlashMode flashMode = FlashMode.off;
  late CameraDescription cameraDescription;

  @override
  void initState() {
    initCamera(cameras[1]);
    super.initState();
  }

  void initCamera(CameraDescription description) {
    try {
      controller = CameraController(description, ResolutionPreset.high);
      controller.initialize().then((value) {
        if (!mounted) {
          return;
        }
        controller.setFlashMode(flashMode);
        cameraDescription = controller.description;
        setState(() {});
      });
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          default:
            break;
        }
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kamera',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      body: CameraPreview(controller),
      floatingActionButton: ElevatedButton(
          onPressed: _takePicture, child: const Icon(Icons.camera)),
    );
  }

  Future<void> _takePicture() async {
    var navigate = Navigator.of(context);
    try {
      final XFile imageFile = await controller.takePicture();

      // final Uint8List bytes = await imageFile.readAsBytes();
      // final img.Image? image = img.decodeImage(Uint8List.fromList(bytes));
      // // final faceDetector = FaceDetector(options: options);
      // final List<double> blurResult = await readImageFile(imageFile.path);
      // log('ngeblur: ${blurResult.first}');
      // double brightness = _calculateImageBrightness(image!);

      // final gambar = File(imageFile.path);
      // final faces =
      //     await _faceDetector.processImage(ml.InputImage.fromFile(gambar));

      navigate.push(MaterialPageRoute(
        builder: (context) => CameraResult(image: imageFile.path),
      ));

      setState(() {});

      // log('Brightness: $brightness');
    } catch (e) {
      debugPrint('Error taking picture: $e');
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
