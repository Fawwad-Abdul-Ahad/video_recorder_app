import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'dart:io';

class CameraUI extends StatefulWidget {
  final CameraController? cameraController;
  final bool isVideoCapture; // Flag to determine if it's video capture mode

  const CameraUI({super.key, required this.cameraController, this.isVideoCapture = false});

  @override
  _CameraUIState createState() => _CameraUIState();
}

class _CameraUIState extends State<CameraUI> {
  bool isRecording = false; // Track recording status
  XFile? videoFile; // To store the video file

  @override
  Widget build(BuildContext context) {
    // Check if the camera is initialized
    if (widget.cameraController == null || !widget.cameraController!.value.isInitialized) {
      return const Center(
        child: SpinKitRotatingPlain(
          color: Colors.red,
          size: 80,
        ),
      );
    }

    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Camera preview widget
          SizedBox(
            height: Get.height * 0.6,
            width: Get.width * 0.9,
            child: CameraPreview(widget.cameraController!),
          ),
          SizedBox(height: Get.height * 0.02),
          // Capture button for video
          IconButton(
            onPressed: () async {
              if (isRecording) {
                // Stop recording if already recording
                videoFile = await widget.cameraController!.stopVideoRecording();
                Gal.putVideo("$videoFile");
                setState(() {
                  isRecording = false;
                });
                Get.snackbar('Video Saved', 'Video recorded successfully!',
                    snackPosition: SnackPosition.BOTTOM);

                // Display video file path or play video
                Get.dialog(
                  AlertDialog(
                    title: const Text('Video Recorded'),
                    content: Text('Video saved at: ${videoFile!.path}'),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } else {
                // Start recording
                await widget.cameraController!.startVideoRecording();
                setState(() {
                  isRecording = true;
                });
              }
            },
            icon: Icon(
              isRecording ? Icons.stop_circle : Icons.videocam_rounded,
              size: 60,
              color: isRecording ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
