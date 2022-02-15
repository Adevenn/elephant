import 'dart:typed_data';

import '../../Model/Cells/Book/sheet.dart';
import '/Model/cell.dart';
import '/Model/Elements/element.dart';

abstract class InteractionToController{

  /* NETWORK */

  ///Try to connect to server and [database]
  ///
  ///If connection fails => Exception
  Future<void> testConnection(String ip, int port, String database, String userName, String password);
  ///Return cells that match with the [research] word
  Future<List<Cell>> getCells([String research = '']);
  ///Return sheets thant match with [idCell]
  Future<List<Sheet>> getSheets(int idCell);
  ///Return elements that match with [idSheet]
  Future<List<Element>> getElements(int idSheet);

  Future<void> addCell(String title, String subtitle, String type);
  Future<void> addSheet(int idCell, String title, String subtitle);
  Future<void> addCheckbox(int idParent);
  Future<void> addImage(int idParent, Uint8List previewImage, Uint8List rawImage);
  Future<void> addTexts(int idParent, int txtType);
  Future<void> deleteItem(String type, int index);
  Future<void> updateItem(String type, Map<String, dynamic> jsonValues);
  Future<void> updateOrder(String type, List<Object> list);
  Future<Uint8List> getRawImage(int idImage);
  Future<Sheet> getSheet(int idCell, int sheetIndex);
}