import 'package:elephant_client/Model/Cells/cell.dart';
import 'package:elephant_client/View/option_screen.dart';
import 'package:elephant_client/View/loading_screen.dart';
import 'package:flutter/material.dart';

import 'delete_page_dialog.dart';

class PageScreen extends StatefulWidget {
  final Cell cell;
  final int selectedPageId;
  final int index;

  const PageScreen(
      {Key? key,
      required this.cell,
      required this.index,
      required this.selectedPageId})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  Cell get cell => widget.cell;

  int get selectedPageId => widget.selectedPageId;

  int get index => widget.index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, index),
          ),
          title: const Text('Pages')),
      endDrawer: const Drawer(child: OptionScreen()),
      body: FutureBuilder<void>(
          future: cell.getPages(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const LoadingScreen();
              case ConnectionState.active:
              case ConnectionState.done:
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(children: [
                    Expanded(
                      child: ReorderableListView(
                        onReorder: (int oldIndex, int newIndex) async {
                          cell.reorderPages(oldIndex, newIndex);
                          setState(() {});
                        },
                        children: [
                          for (var index = 0;
                              index < cell.pages.length;
                              index++)
                            Dismissible(
                                key: UniqueKey(),
                                background:
                                    Container(color: const Color(0xBCC11717)),
                                child: ((() {
                                  if (cell.pages[index].id == selectedPageId) {
                                    return ListTile(
                                        leading: const Icon(
                                            Icons.text_snippet_rounded),
                                        title: Text(
                                          cell.pages[index].title,
                                          style: const TextStyle(
                                              color: Colors.amber),
                                        ),
                                        subtitle: Text(
                                          cell.pages[index].subtitle,
                                          style: const TextStyle(
                                              color: Colors.amber),
                                        ),
                                        onTap: () =>
                                            Navigator.pop(context, index));
                                  } else {
                                    return ListTile(
                                        leading: const Icon(
                                            Icons.text_snippet_rounded),
                                        title: Text(cell.pages[index].title),
                                        subtitle:
                                            Text(cell.pages[index].subtitle),
                                        onTap: () =>
                                            Navigator.pop(context, index));
                                  }
                                })()),
                                onDismissed: (direction) async {
                                  bool result = await showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (BuildContext context) =>
                                          DeletePageDialog(
                                              pageTitle:
                                                  cell.pages[index].title));
                                  if (result) {
                                    await cell.deletePage(index);
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
                          title: const Text('Add page'),
                          onTap: () async {
                            await cell.addPage();
                            setState(() {});
                          },
                        )
                      ],
                    ),
                  ]),
                );
            }
          }),
    );
  }
}
