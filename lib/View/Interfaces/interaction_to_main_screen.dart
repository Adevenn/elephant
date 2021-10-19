import '/../Model/Elements/element.dart';
import '/../Model/cell.dart';
import '/../Model/sheet.dart';

abstract class InteractionToMainScreen{

  void getDefaultCell();

  Future<void> selectCurrentCell(int index);
  Future<void> setCurrentSheet(int index);
  Future<List<Cell>> updateCells([String matchWord = '']);
  Future<List<Sheet>> updateSheets();
  Future<List<Element>> updateElements();
  Future<void> updateSheetsOrder();
  Future<void> updateElementsOrder();

  Future<void> addCell(String title, String subtitle, String type);
  Future<void> addSheet(String title, String subtitle);
  Future<void> addTexts(int type);
  Future<void> addImage();
  Future<void> addCheckbox();

  Future<void> deleteCell(int index);
  Future<void> deleteSheet(int index);
  Future<void> deleteElement(String type, int index);

}