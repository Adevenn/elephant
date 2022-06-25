import 'dart:convert';

import 'package:drag_and_drop_gridview/devdrag.dart';
import 'package:flutter/material.dart';
import '/Network/client.dart';
import '/Model/Elements/element_custom.dart';

class VerticalList extends StatefulWidget {
  final List<ElementCustom> elements;

  const VerticalList({Key? key, required this.elements}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateElemScreenTemplate();
}

class _StateElemScreenTemplate extends State<VerticalList> {
  List<ElementCustom> get elements => widget.elements;

  int variableSet = 0;
  final ScrollController _scrollController = ScrollController();

  //double width;
  //double height;

  Future<void> updateElemOrder(List<ElementCustom> list) async {
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
            ElementCustom item = elements.removeAt(oldIndex);
            elements.insert(newIndex, item);
            await updateElemOrder(elements);
            setState(() {});
          },
          itemCount: elements.length,
          padding: const EdgeInsets.all(20),
          onWillAccept: null,
          itemBuilder: (context, index) => Card(
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
          )),
    );
  }
}
