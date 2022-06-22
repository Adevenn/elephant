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
import 'Interfaces/interaction_view.dart';
import 'SignIn/sign_in_screen.dart';

///Functions in common for all classes in View
class ControllerView implements InteractionView {
  start() {
    runApp(MyApp(interView: this));
  }

  @override
  List<Widget> elementsToWidgets(
      List<Object> items, InteractionView interView) {
    List<Widget> _widgets = [];
    for (var element in items) {
      switch (element.runtimeType) {
        case text.Text:
          _widgets.add(TextFieldCustom(
              key: UniqueKey(),
              texts: element as text.Text));
          break;
        case img.Image:
          _widgets.add(ImagePreview(
              image: element as img.Image,
              key: UniqueKey()));
          break;
        case cb.Checkbox:
          _widgets.add(CheckboxCustom(
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
            SignInScreen(interView: this),
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
            SelectCellScreen(interView: this),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  final InteractionView interView;

  const MyApp({required this.interView, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Netia',
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
