import 'package:elephant_client/Model/Cells/cell.dart';
import 'package:elephant_client/Network/client.dart';

class CellList {
  List<Cell> cells = [];

  CellList();

  ///Return cells that match with the [researchWord]
  Future<List<Cell>> getCells(String researchWord) async {
    var result =
        await Client.requestResult('cells', {'match_word': researchWord});
    return List<Cell>.from(result.map((model) => Cell.fromJson(model)));
  }

  ///Add cell
  Future<void> addCell(Cell cell) async =>
      await Client.request('addCell', cell.toJson());

  ///Delete cell
  Future<void> deleteCell(int index) async =>
      await Client.deleteItem(cells[index].id, 'cell');

  ///Update cell info
  Future<void> updateItem(Cell cell) async =>
      await Client.request('updateCell', cell.toJson());

  ///Check if cell title is available
  bool isCellTitleValid(String title) {
    for (int i = 0; i < cells.length; i++) {
      if (cells[i].title == title) {
        return false;
      }
    }
    return true;
  }
}
