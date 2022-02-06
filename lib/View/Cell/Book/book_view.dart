import 'package:flutter/material.dart';
import 'package:my_netia_client/View/Cell/Book/book_element_view.dart';
import '/Model/cell.dart';
import '/View/Elements/items_screen.dart';
import '/View/Interfaces/interaction_to_view_controller.dart';
import '/View/Cell/Book/book_floating_btn.dart';
import 'Sheet/sheet_screen.dart';

class BookView extends StatelessWidget {
  final InteractionToViewController interView;
  final Cell cell;

  const BookView({Key? key, required this.interView, required this.cell})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BookElemView(interView: interView, cell: cell),
      floatingActionButton: BookFloatingBtn(interView: interView),
      bottomSheet: Container(
        margin: const EdgeInsets.all(15),
        child: Tooltip(
          message: 'Sheets',
          child: FloatingActionButton(
            heroTag: 'sheetsBtn',
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SheetScreen(interView: interView)));
            },
            child: const Icon(Icons.text_snippet),
          ),
        ),
      ),
    );
  }
}
