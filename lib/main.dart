import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isFalse = false;
  String? filePath;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        theme: ThemeData.light(useMaterial3: true),
        home: Scaffold(
          body: Center(
            child: Container(
              child: Container(
                child: filePath != null
                    ? Image.file(File(filePath!))
                    : Icon(Icons.image_aspect_ratio),
              ),
            ),
          ),
          bottomSheet: ElevatedButton(
            onPressed: () async {
              filePath = await CropImage().uploadImage(context, 100, 100);
              setState(() {});
            },
            child: Text("Show dailog"),
          ),
        ));
  }
}

class CropImage {
  Future<String> uploadImage(context, width, height) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return _cropImage(context, pickedFile.path, width, height);
    } else {
      // Navigator.pop(context);
      return '';
    }
  }

  Future<String> _cropImage(context, pickedFile, width, height) async {
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile ?? "",
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 100,
        aspectRatio: CropAspectRatio(
            ratioX: double.parse(width.toString()),
            ratioY: double.parse(height.toString())),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.red,
            toolbarWidgetColor: Colors.transparent,
            lockAspectRatio: true,
          ),
          IOSUiSettings(
            title: 'Cropper',
          ),
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 520,
              height: 520,
            ),
            viewPort:
                const CroppieViewPort(width: 480, height: 480, type: 'circle'),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          ),
        ],
      );

      if (croppedFile != null) {
        return croppedFile.path;
      } else {
        return '';
      }
    }
    return '';
  }
}

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 0, 0, 0),
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
