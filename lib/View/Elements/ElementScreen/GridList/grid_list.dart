import 'dart:convert';

import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter/material.dart';
import '/Network/client.dart';
import '/Model/Elements/element.dart' as elem;

class VerticalList extends StatefulWidget {
  final List<elem.Element> elements;
  final List<Widget> widgets;

  const VerticalList({Key? key,
    required this.elements,
    required this.widgets})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateElemScreenTemplate();
}

class _StateElemScreenTemplate extends State<VerticalList> {
  List<elem.Element> get elements => widget.elements;

  List<Widget> get widgets => widget.widgets;

  int variableSet = 0;
  final ScrollController _scrollController = ScrollController();
  //double width;
  //double height;

  Future<void> updateElemOrder(List<elem.Element> list) async {
    var jsonList = <String>[];
    for (var i = 0; i < list.length; i++) {
      jsonList.add(jsonEncode(list[i]));
    }
    await Client.request('updateElementOrder', {'elem_order': jsonList});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DragAndDropGridView(
          controller: _scrollController,
          onReorder: (int oldIndex, int newIndex) async {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            elem.Element item = elements.removeAt(oldIndex);
            Widget widget = widgets.removeAt(oldIndex);
            elements.insert(newIndex, item);
            widgets.insert(newIndex, widget);
            await updateElemOrder(elements);
            setState(() {});
          },
          itemCount: elements.length,
          padding: const EdgeInsets.all(20),
          onWillAccept: null,
          itemBuilder: (context, index) =>
              Card(
                elevation: 2,
                child: LayoutBuilder(
                  builder: (context, constrains) {
                    if (variableSet == 0) {
                      //height = constrains.maxHeight;
                      //width = constrains.maxWidth;
                      variableSet++;
                    }
                    return GridTile(
                      child: Card(),
                    );
                  },
                ),
              ),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 4.5,
          )
      ),
    );
  }
}
