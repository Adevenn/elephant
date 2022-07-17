import 'dart:convert';
import 'package:flutter/material.dart';

import '/Network/client.dart';
import '/Model/Elements/element_custom.dart';
import 'delete_element_dialog.dart';

class VerticalList extends StatefulWidget {
  final List<ElementCustom> elements;

  const VerticalList({Key? key, required this.elements}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateVerticalList();
}

class _StateVerticalList extends State<VerticalList> {
  List<ElementCustom> get elements => widget.elements;

  Future<void> deleteItem(String request, int id) async {
    try {
      await Client.request(request, {'id': id});
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateElemOrder(List<ElementCustom> list) async {
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
              ElementCustom item = elements.removeAt(oldIndex);
              elements.insert(newIndex, item);
              await updateElemOrder(elements);
              setState(() {});
            },
            children: [
              for (var index = 0; index < elements.length; index++)
                Dismissible(
                  key: UniqueKey(),
                  child: _VerticalListElem(
                      key: UniqueKey(), widget: elements[index].toWidget()),
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

class _VerticalListElem extends StatelessWidget {
  final Widget widget;

  const _VerticalListElem({required Key key, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(child: widget),
    );
  }
}
