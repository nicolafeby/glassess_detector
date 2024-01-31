import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:glassess_detector/menu.dart';

late List<CameraDescription> cameras;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initCameras();
  }
  // This widget is the root of your application.

  Future<void> initCameras() async {
    try {
      availableCameras().then((value) {
        cameras = value;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MenuPage(),
    );
  }
}



// class DetectedObject {
//   /// Tracking ID of object. If tracking is disabled it is null.
//   final int? trackingId;

//   /// Rect that contains the detected object.
//   final Rect boundingBox;

//   /// List of [Label], identified for the object.
//   final List<Label> labels;

//   /// Constructor to create an instance of [DetectedObject].
//   DetectedObject(
//       {required this.boundingBox,
//       required this.labels,
//       required this.trackingId});

//   /// Returns an instance of [DetectedObject] from a given [json].
//   factory DetectedObject.fromJson(Map<dynamic, dynamic> json) {
//     final boundingBox = RectJson.fromJson(json['rect']);
//     final trackingId = json['trackingId'];
//     final labels = <Label>[];
//     for (final dynamic label in json['labels']) {
//       labels.add(Label.fromJson(label));
//     }
//     return DetectedObject(
//       boundingBox: boundingBox,
//       labels: labels,
//       trackingId: trackingId,
//     );
//   }
// }
