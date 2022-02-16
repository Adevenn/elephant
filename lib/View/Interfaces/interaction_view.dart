import 'package:flutter/material.dart';
import '/Model/Cells/Book/sheet.dart';
import '/Model/Elements/image.dart' as img;

abstract class InteractionView {
  void gotoLoginScreen(BuildContext context);

  void gotoCellScreen(BuildContext context);

  Future<List<img.Image>> pickImage(Sheet sheet);

  List<Widget> elementsToWidgets(
      List<Object> items, InteractionView interView);
}
