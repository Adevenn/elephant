import 'dart:typed_data';

import '/Model/Elements/image.dart';
import '/Model/Cells/Book/sheet.dart';
import '/Model/Elements/element.dart';

abstract class InteractionMain {

  ///Return elements that match with [idSheet]
  Future<List<Element>> getElements(int idSheet);

  Future<void> deleteItem(String request, int index);

  Future<void> updateItem(String type, Map<String, dynamic> jsonValues);

  Future<void> updateElemOrder(List<Element> list);
}
