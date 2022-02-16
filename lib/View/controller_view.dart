import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_compression/image_compression.dart';
import '/Model/Cells/Book/sheet.dart';
import '/Model/Elements/checkbox.dart' as cb;
import '/Model/Elements/image.dart' as img;
import '/Model/Elements/text.dart' as text;

import 'Elements/checkbox_custom.dart';
import 'Elements/image_preview.dart';
import 'Elements/text_field_custom.dart';
import 'SelectCell/select_cell_screen.dart';
import 'Interfaces/interaction_to_controller.dart';
import 'Interfaces/interaction_to_view_controller.dart';
import 'Login/login_screen.dart';

///Functions in common for all classes in View
class ControllerView implements InteractionToViewController {
  final InteractionToController interMain;

  ControllerView(this.interMain);

  start() {
    runApp(MyApp(interMain: interMain, interView: this));
  }

  @override
  List<Widget> elementsToWidgets(
      List<Object> items, InteractionToViewController interView) {
    List<Widget> _widgets = [];
    for (var element in items) {
      switch (element.runtimeType) {
        case text.Text:
          _widgets.add(TextFieldCustom(
              interMain: interMain,
              key: UniqueKey(),
              texts: element as text.Text));
          break;
        case img.Image:
          _widgets.add(ImagePreview(
              interMain: interMain,
              image: element as img.Image,
              key: UniqueKey()));
          break;
        case cb.Checkbox:
          _widgets.add(CheckboxCustom(
              interMain: interMain,
              key: UniqueKey(),
              checkbox: element as cb.Checkbox));
          break;
        default:
          throw Exception('Unknown element type');
      }
    }
    return _widgets;
  }

  @override
  Future<List<img.Image>> pickImage(Sheet sheet) async {
    var images = <img.Image>[];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
        dialogTitle: 'my_netia image selection');
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
        images.add(img.Image(
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
        builder: (BuildContext context) =>
            LoginScreen(interMain: interMain, interView: this),
      ),
      (route) => false,
    );
  }

  @override
  void gotoCellScreen(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            CellScreen(interMain: interMain, interView: this),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final InteractionToViewController interView;
  final InteractionToController interMain;

  const MyApp({required this.interMain, required this.interView, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyNetia',
      /*theme: ThemeData.(
        primarySwatch: Colors.blue,
      ),*/
      theme: ThemeData.dark(),
      home: LoginScreen(interMain: interMain, interView: interView),
    );
  }
}

class MainScreenException implements Exception {
  InteractionToViewController interView;
  BuildContext context;

  MainScreenException(
      {required this.interView, required this.context, required Object error}) {
    interView.gotoLoginScreen(context);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connexion with server lost')));
    print(error);
    //TODO: Send error by mail
  }
}
