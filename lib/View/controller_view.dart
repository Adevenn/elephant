import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_compression/image_compression.dart';

import '../Model/Cells/sheet.dart';
import '/Model/Elements/image_custom.dart';
import 'SelectCell/select_cell_screen.dart';
import 'Interfaces/interaction_view.dart';
import 'SignIn/sign_in_screen.dart';

///Functions in common for all classes in View
class ControllerView implements InteractionView {
  start() {
    runApp(MyApp(interView: this));
  }

  @override
  Future<List<ImageCustom>> pickImage(Sheet sheet) async {
    var images = <ImageCustom>[];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
        dialogTitle: 'elephant image selection');
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      for (var file in files) {
        var image =
            ImageFile(filePath: file.path, rawBytes: file.readAsBytesSync());
        var imageCompressed = compress(ImageFileConfiguration(
            input: image,
            config: const Configuration(
                pngCompression: PngCompression.bestCompression,
                jpgQuality: 25)));
        images.add(ImageCustom(
            id: -1,
            imgPreview: imageCompressed.rawBytes,
            imgRaw: image.rawBytes,
            idParent: sheet.id,
            idOrder: -1));
      }
    }
    return images;
  }

  @override
  void gotoLoginScreen(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SignInScreen(interView: this),
      ),
      (route) => false,
    );
  }

  @override
  void gotoCellScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SelectCellScreen(interView: this),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final InteractionView interView;

  const MyApp({required this.interView, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Elephant',
      /*theme: ThemeData.(
        primarySwatch: Colors.blue,
      ),*/
      theme: ThemeData.dark(),
      home: SignInScreen(interView: interView),
    );
  }
}

class MainScreenException implements Exception {
  InteractionView interView;
  BuildContext context;

  MainScreenException(
      {required this.interView, required this.context, required Object error}) {
    interView.gotoLoginScreen(context);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connexion with server lost')));
    //TODO: Send error by mail
  }
}
