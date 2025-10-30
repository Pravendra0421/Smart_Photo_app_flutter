import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';

class TakeSelfieScreen extends StatefulWidget {
  const TakeSelfieScreen({super.key});

  @override
  State<TakeSelfieScreen> createState() => _TakeSelfieScreenState();
}

class _TakeSelfieScreenState extends State<TakeSelfieScreen> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      // Use the front camera if available
      CameraDescription? frontCamera = _cameras?.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first, // Fallback to the first camera
      );

      if (frontCamera == null) {
        print("No suitable camera found!");
        Get.back(); // Go back if no camera
        return;
      }

      _cameraController = CameraController(
        frontCamera,
        ResolutionPreset.high, // Choose resolution
        enableAudio: false,   // We don't need audio for a selfie
      );

      await _cameraController!.initialize();
      if (!mounted) return; // Check if the widget is still in the tree
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      print("Error initializing camera: $e");
      Get.back(); // Go back on error
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose(); // Dispose controller when screen is closed
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (!_isCameraInitialized || _cameraController!.value.isTakingPicture) {
      return;
    }
    try {
      final XFile imageFile = await _cameraController!.takePicture();
      // Return the captured image file path back to the previous screen
      Get.back(result: File(imageFile.path));
    } catch (e) {
      print("Error taking picture: $e");
      Get.snackbar("Error", "Could not capture image.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Take a Selfie")),
      body: _isCameraInitialized
          ? Stack(
        alignment: Alignment.center,
        children: [
          // Camera Preview fills the screen
          Positioned.fill(
            child: CameraPreview(_cameraController!),
          ),
          // Face Outline Overlay
          // You'll need an SVG or PNG asset for the outline
          // Image.asset(
          //   'assets/images/face_outline.png', // <-- Make sure you have this asset
          //   width: MediaQuery.of(context).size.width * 0.7, // Adjust size as needed
          //   color: Colors.white.withOpacity(0.8), // Make it semi-transparent white
          // ),
          // Instructions Text
          Positioned(
            top: 50,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Colors.black.withOpacity(0.5),
              child: const Text(
                "Fit your face exactly within the border",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          // Capture Button Area
          Positioned(
            bottom: 30,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _takePicture,
                  style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      backgroundColor: Colors.blueAccent
                  ),
                  child: const Icon(Icons.camera_alt, size: 30),
                ),
                const SizedBox(height: 10),
                const Text(
                  "You can only re-upload your own selfie.\nOR, go to settings to add new profiles.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()), // Show loading while camera initializes
    );
  }
}