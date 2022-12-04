import 'dart:convert';

import 'package:flutter/material.dart';
import '/Network/client.dart';
import '/View/loading_screen.dart';
import '/Model/Cells/cell.dart';
import '/View/Options/option_screen.dart';
import 'add_sheet_dialog.dart';
import 'delete_sheet_dialog.dart';
import '/Model/Cells/sheet.dart';

class SheetScreen extends StatefulWidget {
  final Cell cell;
  final int selectedSheetId;
  final int index;

  const SheetScreen(
      {Key? key,
      required this.cell,
      required this.index,
      required this.selectedSheetId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SheetScreenState();
}

class _SheetScreenState extends State<SheetScreen> {
  Cell get cell => widget.cell;

  int get selectedSheetId => widget.selectedSheetId;

  int get index => widget.index;

  ///Return sheets that match with [idCell]
  Future<List<Sheet>> getSheets(int idCell) async {
    var sheets = <Sheet>[];
    try {
      var result = await Client.requestResult('sheets', {'id_cell': idCell});
      sheets = List<Sheet>.from(result.map((model) => Sheet.fromJson(model)));
    } catch (e) {
      throw Exception(e);
    }
    return sheets;
  }

  Future<void> addSheet(int idCell, String title, String subtitle) async {
    try {
      await Client.request('addSheet',
          {'id_cell': idCell, 'title': title, 'subtitle': subtitle});
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateSheetOrder(List<Sheet> list) async {
    var jsonList = <String>[];
    for (var i = 0; i < list.length; i++) {
      jsonList.add(jsonEncode(list[i]));
    }
    await Client.request('updateSheetOrder', {'sheet_order': jsonList});
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, index),
          ),
          title: const Text('Sheets')),
      endDrawer: const Drawer(child: OptionScreen()),
      body: FutureBuilder<List<Sheet>>(
          future: getSheets(cell.id),
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
                        await updateSheetOrder(sheets);
                      },
                      children: [
                        for (var index = 0; index < sheets.length; index++)
                          Dismissible(
                              key: UniqueKey(),
                              background:
                                  Container(color: const Color(0xBCC11717)),
                              child: ((() {
                                if (sheets[index].id == selectedSheetId) {
                                  return ListTile(
                                      leading: const Icon(
                                          Icons.text_snippet_rounded),
                                      title: Text(
                                        sheets[index].title,
                                        style: const TextStyle(
                                            color: Colors.amber),
                                      ),
                                      subtitle: Text(
                                        sheets[index].subtitle,
                                        style: const TextStyle(
                                            color: Colors.amber),
                                      ),
                                      onTap: () =>
                                          Navigator.pop(context, index));
                                } else {
                                  return ListTile(
                                      leading: const Icon(
                                          Icons.text_snippet_rounded),
                                      title: Text(sheets[index].title),
                                      subtitle: Text(sheets[index].subtitle),
                                      onTap: () =>
                                          Navigator.pop(context, index));
                                }
                              })()),
                              onDismissed: (direction) async {
                                bool result = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) =>
                                        DeleteSheetDialog(
                                            sheetTitle: sheets[index].title));
                                if (result) {
                                  await Client.deleteItem(
                                      sheets[index].id, 'sheet');
                                  sheets.removeAt(index);
                                }
                                setState(() {});
                              })
                      ],
                    ),
                  ),
                  Column(
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
                            await addSheet(cell.id, list[0], list[1]);
                            setState(() {});
                          }
                        },
                      )
                    ],
                  ),
                ]),
              );
            } else {
              return const LoadingScreen();
            }
          }),
    );
  }
}
