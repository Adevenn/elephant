import 'dart:convert';
import 'package:flutter/material.dart';

import '/Network/client.dart';
import '/Model/Elements/element.dart' as elem;
import '../delete_element_dialog.dart';
import 'vertical_list_element.dart';

class VerticalList extends StatefulWidget {
  final List<elem.Element> elements;
  final List<Widget> widgets;

  const VerticalList(
      {Key? key,
      required this.elements,
      required this.widgets})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateElemScreenTemplate();
}

class _StateElemScreenTemplate extends State<VerticalList> {
  List<elem.Element> get elements => widget.elements;

  List<Widget> get widgets => widget.widgets;

  Future<void> deleteItem(String request, int id) async {
    try {
      await Client.request(request, {'id': id});
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateElemOrder(List<elem.Element> list) async {
    var jsonList = <String>[];
    for (var i = 0; i < list.length; i++) {
      jsonList.add(jsonEncode(list[i]));
    }
    await Client.request('updateElementOrder', {'elem_order': jsonList});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container()),
        Expanded(
          flex: 5,
          child: ReorderableListView(
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
            children: [
              for (var index = 0; index < widgets.length; index++)
                Dismissible(
                  key: UniqueKey(),
                  child: VerticalListElem(
                      key: UniqueKey(), widget: widgets[index]),
                  onDismissed: (direction) async {
                    bool result = await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => DeleteElementDialog(
                            elementType:
                                elements[index].runtimeType.toString()));
                    if (result) {
                      await deleteItem('deleteElement', elements[index].id);
                      elements.removeAt(index);
                      widgets.removeAt(index);
                    }
                    setState(() {});
                  },
                  background: Container(color: const Color(0xBCC11717)),
                )
            ],
          ),
        ),
        Expanded(child: Container()),
      ],
    );
  }
}
