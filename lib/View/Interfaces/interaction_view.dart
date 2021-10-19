import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../Model/sheet.dart';
import '../../Model/cell.dart';
import '../../Model/Elements/element.dart' as elem;

abstract class InteractionView{

  ///Return the default Cell
  Cell getDefaultCell();

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
  Future<List<elem.Element>> getElements(int idSheet);

  Future<void> addCell(String title, String subtitle, String type);
  Future<void> addSheet(int idCell, String title, String subtitle, int idOrder);
  Future<void> addCheckbox(int idParent, int idOrder);
  Future<void> addImage(int idParent, Uint8List data, int idOrder);
  Future<void> addTexts(int idParent, int txtType, int idOrder);
  Future<void> deleteObject(String type, int index);
  Future<void> updateObject(String type, Map<String, dynamic> jsonValues);

  /* NAVIGATE */
  ///Load the login screen
  void gotoLoginScreen(BuildContext context);
  ///Load the main screen
  void gotoMainScreen(BuildContext context);
}