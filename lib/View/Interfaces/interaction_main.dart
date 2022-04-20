import 'dart:typed_data';

import '/Model/Elements/image.dart';
import '/Model/Cells/Book/sheet.dart';
import '/Model/cell.dart';
import '/Model/Elements/element.dart';

abstract class InteractionMain {
  ///Try to login
  ///
  ///If connection fails => Exception
  Future<void> trySignIn(String username, String password);

  ///Try to sign in a new user
  ///
  ///If connection fails => Exception
  Future<void> tryAddAccount(String username, String password);

  ///Return cells that match with the [research] word
  Future<List<Cell>> getCells([String research = '']);

  ///Return sheets thant match with [idCell]
  Future<List<Sheet>> getSheets(int idCell);

  ///Return elements that match with [idSheet]
  Future<List<Element>> getElements(int idSheet);

  Future<void> addCell(String request, Map<String, dynamic> jsonValues);

  Future<void> addSheet(int idCell, String title, String subtitle);

  Future<void> addCheckbox(int idParent);

  Future<void> addImage(List<Image> images);

  Future<void> addTexts(int idParent, int txtType);

  Future<void> deleteItem(String request, int index);

  Future<void> updateItem(String type, Map<String, dynamic> jsonValues);

  Future<void> updateSheetOrder(List<Sheet> list);

  Future<void> updateElemOrder(List<Element> list);

  Future<Uint8List> getRawImage(int idImage);

  Future<Sheet> getSheet(int idCell, int sheetIndex);
}
