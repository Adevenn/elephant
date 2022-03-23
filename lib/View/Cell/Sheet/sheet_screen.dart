import 'package:flutter/material.dart';
import '/View/Interfaces/interaction_view.dart';
import '/View/loading_screen.dart';
import '/Model/cell.dart';
import '/View/Options/option_screen.dart';
import 'add_sheet_dialog.dart';
import 'delete_sheet_dialog.dart';
import '/Model/Cells/Book/sheet.dart';
import '/View/Interfaces/interaction_main.dart';

class SheetScreen extends StatefulWidget {
  final InteractionMain interMain;
  final InteractionView interView;
  final Cell cell;
  final int index;

  const SheetScreen(
      {Key? key,
      required this.interMain,
      required this.interView,
      required this.cell,
      required this.index})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SheetScreenState();
}

class _SheetScreenState extends State<SheetScreen> {
  InteractionMain get interMain => widget.interMain;

  InteractionView get interView => widget.interView;

  Cell get cell => widget.cell;

  int get index => widget.index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, index),
          ),
          title: const Text('Sheets')),
      endDrawer: Drawer(child: OptionScreen(interView: interView)),
      body: FutureBuilder<List<Sheet>>(
          future: interMain.getSheets(cell.id),
          builder: (BuildContext context, AsyncSnapshot<List<Sheet>> snapshot) {
            if (snapshot.hasData) {
              var sheets = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.all(10),
                child: Column(children: [
                  Expanded(
                    child: ReorderableListView(
                      onReorder: (int oldIndex, int newIndex) async {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        Sheet item = sheets.removeAt(oldIndex);
                        sheets.insert(newIndex, item);
                        await interMain.updateOrder('Sheet', sheets);
                        setState(() {});
                      },
                      children: [
                        for (var index = 0; index < sheets.length; index++)
                          Dismissible(
                              key: UniqueKey(),
                              background:
                                  Container(color: const Color(0xBCC11717)),
                              child: ListTile(
                                  leading:
                                      const Icon(Icons.text_snippet_rounded),
                                  title: Text(sheets[index].title),
                                  subtitle: Text(sheets[index].subtitle),
                                  onTap: () => Navigator.pop(context, index)),
                              onDismissed: (direction) async {
                                bool result = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) =>
                                        DeleteSheetDialog(
                                            sheetTitle: sheets[index].title));
                                if (result) {
                                  await interMain.deleteItem(
                                      'deleteSheet', sheets[index].id);
                                }
                                setState(() {});
                              })
                      ],
                    ),
                  ),
                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Column(
                      children: [
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.add_rounded),
                          title: const Text('Add sheet'),
                          onTap: () async {
                            var list = await showDialog<List<String>?>(
                              context: context,
                              builder: (BuildContext context) =>
                                  AddSheetDialog(sheets: sheets),
                            );
                            if (list != null) {
                              await interMain.addSheet(
                                  cell.id, list[0], list[1]);
                              setState(() {});
                            }
                          },
                        )
                      ],
                    ),
                  )
                ]),
              );
            } else {
              return const LoadingScreen();
            }
          }),
    );
  }
}
