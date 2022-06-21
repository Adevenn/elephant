import 'dart:typed_data';

import '/Model/Elements/image.dart';
import '/Model/Cells/Book/sheet.dart';
import '/Model/Elements/element.dart';

abstract class InteractionMain {

  ///Return elements that match with [idSheet]
  Future<List<Element>> getElements(int idSheet);

  Future<void> addSheet(int idCell, String title, String subtitle);

  Future<void> addCheckbox(int idParent);

  Future<void> addImage(List<Image> images);

  Future<void> addTexts(int idParent, int txtType);

  Future<void> deleteItem(String request, int index);

  Future<void> updateItem(String type, Map<String, dynamic> jsonValues);

  Future<void> updateElemOrder(List<Element> list);

  Future<Uint8List> getRawImage(int idImage);

  //Future<Sheet> getSheet(int idCell, int sheetIndex);
}
