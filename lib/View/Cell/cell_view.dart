import 'package:flutter/material.dart';
import '/View/Interfaces/interaction_main.dart';
import '/Model/Cells/Book/sheet.dart';
import '/Network/client.dart';
import '../loading_screen.dart';
import '/View/Options/option_screen.dart';
import '/View/Cell/Book/book_view.dart';
import '/View/Interfaces/interaction_view.dart';
import '/Model/cell.dart';
import 'Rank/rank_view.dart';
import 'ToDoList/to_do_list_view.dart';

class CellView extends StatefulWidget {
  final Cell cell;
  final InteractionView interView;
  final InteractionMain interMain;

  const CellView(
      {Key? key,
      required this.cell,
      required this.interView,
      required this.interMain})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateCellView();
}

class _StateCellView extends State<CellView> {
  Cell get cell => widget.cell;

  InteractionView get interView => widget.interView;

  InteractionMain get interMain => widget.interMain;
  Sheet? sheet;
  int sheetIndex = 0;

  Future<Sheet> getSheet(int idCell, int sheetIndex) async {
    try {
      var result = await Client.requestResult(
          'sheet', {'id_cell': idCell, 'sheet_index': sheetIndex});
      return Sheet.fromJson(result);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Sheet>(
        future: getSheet(cell.id, sheetIndex),
        builder: (BuildContext context, AsyncSnapshot<Sheet> snapshot) {
          if (snapshot.hasData && sheet != snapshot.data) {
            sheet = snapshot.data;
            return Scaffold(
              appBar: appBar(context),
              endDrawer: Drawer(child: OptionScreen(interView: interView)),
              body: (() {
                switch (cell.type) {
                  case 'Book':
                    return BookView(
                      interMain: interMain,
                      interView: interView,
                      cell: cell,
                      sheet: sheet!,
                      sheetIndex: sheetIndex,
                      onSheetIndexChange: (int newSheetIndex) {
                        setState(() => sheetIndex = newSheetIndex);
                      },
                    );
                  case 'ToDoList':
                    return ToDoListView(
                        interMain: interMain, interView: interView, cell: cell);
                  case 'Rank':
                    return RankView(
                        interMain: interMain, interView: interView, cell: cell);
                }
              }()),
            );
          } else {
            return const LoadingScreen();
          }
        });
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          Expanded(child: Text(cell.title), flex: 3),
          Expanded(child: Text(cell.subtitle)),
        ],
      ),
    );
  }
}
