import 'package:flutter/material.dart';
import '/View/Interfaces/interaction_main.dart';
import '/View/loading_screen.dart';
import '/Model/Cells/Book/sheet.dart';
import '/View/Cell/Book/book_element_view.dart';
import '/Model/cell.dart';
import '/View/Interfaces/interaction_view.dart';
import '../Sheet/sheet_screen.dart';

class BookView extends StatefulWidget {
  final InteractionMain interMain;
  final InteractionView interView;
  final Cell cell;

  const BookView(
      {Key? key,
      required this.interMain,
      required this.interView,
      required this.cell})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateBookView();
}

class _StateBookView extends State<BookView> {
  InteractionView get interView => widget.interView;

  InteractionMain get interMain => widget.interMain;

  Cell get cell => widget.cell;
  Sheet? sheet;
  int sheetIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: interMain.getSheet(cell.id, sheetIndex),
        builder: (BuildContext context, AsyncSnapshot<Sheet> snapshot) {
          if (snapshot.hasData && sheet != snapshot.data) {
            sheet = snapshot.data;
            return Scaffold(
              body: BookElemView(
                  interMain: interMain, interView: interView, sheet: sheet!),
              bottomSheet: Container(
                margin: const EdgeInsets.all(15),
                child: Tooltip(
                  message: 'Sheets',
                  child: FloatingActionButton(
                    heroTag: 'sheetsBtn',
                    onPressed: () async {
                      var result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SheetScreen(
                                  cell: cell,
                                  interMain: interMain,
                                  interView: interView,
                                  index: sheetIndex)));
                      if (sheetIndex != result) {
                        sheetIndex = result;
                        setState(() {});
                      }
                    },
                    child: const Icon(Icons.text_snippet),
                  ),
                ),
              ),
            );
          } else {
            return const LoadingScreen();
          }
        });
  }
}
