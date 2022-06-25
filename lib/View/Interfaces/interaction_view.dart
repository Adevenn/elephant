import 'package:flutter/material.dart';
import '/Model/Cells/Book/sheet.dart';
import '/Model/Elements/image_custom.dart';

abstract class InteractionView {
  void gotoLoginScreen(BuildContext context);

  void gotoCellScreen(BuildContext context);

  Future<List<ImageCustom>> pickImage(Sheet sheet);
}
