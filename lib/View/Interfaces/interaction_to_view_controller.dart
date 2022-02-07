import 'dart:typed_data';

import 'package:flutter/material.dart';

import '/Model/Elements/element.dart' as elem;
import '/Model/cell.dart';
import '/Model/sheet.dart';

abstract class InteractionToViewController{

  Future<Uint8List> selectRawImage(int idImage);
  Future<Sheet> selectSheet(Cell cell, int sheetIndex);

  Future<void> testConnection(String ip, int port, String database, String username, String password);
  Future<List<Cell>> updateCells([String matchWord = '']);
  Future<List<Sheet>> updateSheets(Cell cell);
  Future<List<elem.Element>> updateElements(Sheet sheet);
  Future<void> updateSheetsOrder(List<Sheet> sheets);
  Future<void> updateElementsOrder(List<elem.Element> elements);
  Future<void> updateItem(String type, Map<String, dynamic> json);

  Future<void> addCell(String title, String subtitle, String type);
  Future<void> addSheet(Cell cell, String title, String subtitle);
  Future<void> addTexts(Sheet sheet, int type);
  Future<void> addImage(Sheet sheet);
  Future<void> addCheckbox(Sheet sheet);

  Future<void> deleteCell(int index);
  Future<void> deleteSheet(int index);
  Future<void> deleteElement(int index);

  void gotoLoginScreen(BuildContext context);
  void gotoCellScreen(BuildContext context);
}