import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:videoapp/widgets/cameraUI.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CameraController? cameraController;
  List<CameraDescription> camerasList = [];

  @override
  void initState() {
    super.initState();
    setupCamera(); // Call setupCamera in initState
  }

  Future<void> setupCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      setState(() {
        camerasList = cameras;
        cameraController = CameraController(
          cameras.first, // Select the first camera
          ResolutionPreset.high,
          enableAudio: true, // Enable audio for video recording
        );
      });
      await cameraController?.initialize();
      setState(() {}); // Rebuild UI after camera initialization
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Video Recorder App"),
        backgroundColor: Colors.red,
      ),
      body: CameraUI(
        cameraController: cameraController,
        isVideoCapture: true, // Pass flag to indicate video mode
      ),
    );
  }
}
