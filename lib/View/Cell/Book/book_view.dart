import 'package:flutter/material.dart';
import '/Model/sheet.dart';
import '/View/Cell/Book/book_element_view.dart';
import '/Model/cell.dart';
import '/View/Interfaces/interaction_to_view_controller.dart';
import '/View/Cell/Book/book_floating_btn.dart';
import 'Sheet/sheet_screen.dart';

class BookView extends StatefulWidget {
  final InteractionToViewController interView;
  final Cell cell;

  const BookView({Key? key, required this.interView, required this.cell})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateBookView();
}

class _StateBookView extends State<BookView> {
  get interView => widget.interView;

  get cell => widget.cell;
  Sheet? sheet;
  int sheetIndex = 0;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: interView.selectSheet(cell, sheetIndex),
        builder: (BuildContext context, AsyncSnapshot<Sheet> snapshot) {
          if (snapshot.hasData && sheet != snapshot.data) {
            sheet = snapshot.data;
            print(sheet!.title);
            return Scaffold(
              body: BookElemView(interView: interView, sheet: sheet!),
              floatingActionButton: BookFloatingBtn(interView: interView),
              bottomSheet: Container(
                margin: const EdgeInsets.all(15),
                child: Tooltip(
                  message: 'Sheets',
                  child: FloatingActionButton(
                    heroTag: 'sheetsBtn',
                    onPressed: () async {
                      sheetIndex = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SheetScreen(
                                  cell: cell,
                                  interView: interView,
                                  index: sheetIndex)));
                      setState(() {});
                    },
                    child: const Icon(Icons.text_snippet),
                  ),
                ),
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting ...'),
                  )
                ],
              ),
            );
          }
        });
  }
}
