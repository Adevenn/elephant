import 'dart:typed_data';

import 'package:flutter/material.dart';

import '/Model/Elements/element.dart' as elem;
import '/Model/cell.dart';
import '/Model/sheet.dart';

abstract class InteractionToViewController{

  Future<Uint8List> selectRawImage(int idImage);
  Future<void> selectCurrentCell(Cell cell);
  Future<void> setCurrentSheetIndex(int index);

  Future<void> testConnection(String ip, int port, String database, String username, String password);
  Future<List<Cell>> updateCells([String matchWord = '']);
  Future<List<Sheet>> updateSheets();
  Future<List<elem.Element>> updateElements();
  Future<void> updateSheetsOrder(List<Sheet> sheets);
  Future<void> updateElementsOrder(List<elem.Element> elements);
  Future<void> updateItem(String type, Map<String, dynamic> json);

  Future<void> addCell(String title, String subtitle, String type);
  Future<void> addSheet(String title, String subtitle);
  Future<void> addTexts(int type);
  Future<void> addImage();
  Future<void> addCheckbox();

  Future<void> deleteCell(int index);
  Future<void> deleteSheet(int index);
  Future<void> deleteElement(int index);

  void gotoLoginScreen(BuildContext context);
  void gotoCellScreen(BuildContext context);
}