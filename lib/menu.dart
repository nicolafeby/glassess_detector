import 'package:flutter/material.dart';
import 'package:glassess_detector/camera_screen.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const CameraScreen(),
              ),
            );
          },
          child: Text('Camera'),
        ),
      ),
    );
  }
}
