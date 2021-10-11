import '../Model/sheet.dart';

abstract class InteractionToMainScreen{

  void getDefaultCell();
  void setStateMainScreen();
  bool isCellTitleValid(String title);
  bool isSheetTitleValid(String title);

  Future<void> selectCurrentCell(int index);
  List<Sheet> getSheets();
  Future<void> setCurrentSheet(int index);
  Future<void> updateCells([String matchWord = '']);
  Future<void> updateSheets();
  Future<void> updateElements();

  Future<void> addCell(String title, String subtitle, String type);
  Future<void> addSheet(String title, String subtitle);
  Future<void> addTexts(int type);
  Future<void> addImage();
  Future<void> addCheckbox();

  Future<void> deleteCell(int index);
  Future<void> deleteSheet(int index);
  Future<void> deleteElement(String type, int index);

}