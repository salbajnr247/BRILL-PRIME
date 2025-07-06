// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
//
// class CameraScreen extends StatefulWidget {
//   // final CameraDescription camera;
//
//   const CameraScreen();
//
//   @override
//   _CameraScreenState createState() => _CameraScreenState();
// }
//
// class _CameraScreenState extends State<CameraScreen> {
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//
//
//   CameraController? controller;
//   File? videoFile;
//   bool isRecording = false;
//
//   @override
//   void initState() {
//     super.initState();
//     availableCameras().then((value) {
//       print(value.length);
//
//       initCamera(value.firstWhere(
//               (element) => element.lensDirection == CameraLensDirection.front));
//     });
//   }
//
//   void initCamera(CameraDescription cameraDescription) {
//     _controller = CameraController(cameraDescription, ResolutionPreset.medium);
//     _controller.initialize().then((_) {
//       if (!mounted) {
//         // return;
//       }
//       setState(() {});
//     });
//   }
//
//
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   _controller = CameraController(
//   //     widget.camera,
//   //     ResolutionPreset.medium,
//   //   );
//   //   _initializeControllerFuture = _controller.initialize();
//   // }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Circular Camera')),
//       body: FutureBuilder<void>(
//         future: _initializeControllerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return Stack(
//               children: [
//                 CameraPreview(_controller),
//                 Center(
//                   child: ClipOval(
//                     child: Container(
//                       width: 200,
//                       height: 200,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.white, width: 5.0),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _takePicture,
//         child: Icon(Icons.camera_alt),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
//
//   void _takePicture() async {
//     try {
//       await _initializeControllerFuture;
//
//       // Ensure that the camera is initialized.
//       if (!_controller.value.isInitialized) {
//         return;
//       }
//
//       // Take the picture.
//       final image = await _controller.takePicture();
//
//       // Save the picture to the gallery.
//       // final appDir = await getTemporaryDirectory();
//       // final fileName = DateTime.now().toString();
//       // final savePath = "${appDir.path}/$fileName.png";
//       // final originalImage = img.decodeImage(File(image.path).readAsBytesSync())!;
//       // final thumbnailImage = img.copyResize(originalImage, width: 100);
//       //
//       // File(image.path).copy(savePath);
//       // print("Image saved to: $savePath");
//
//       // Display the captured image using the thumbnail.
//       // Navigator.push(
//       //   context,
//       //   MaterialPageRoute(
//       //     builder: (context) => DisplayPictureScreen(imagePath: savePath),
//       //   ),
//       // );
//     } catch (e) {
//       print("Error capturing image: $e");
//     }
//   }
// }
//
// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;
//
//   const DisplayPictureScreen({required this.imagePath});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Captured Image')),
//       body: Center(
//         child: Image.file(File(imagePath)),
//       ),
//     );
//   }
// }
