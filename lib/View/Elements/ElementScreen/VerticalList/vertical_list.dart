import 'package:flutter/material.dart';
import '/View/Interfaces/interaction_main.dart';
import '/Model/Elements/element.dart' as elem;
import '../delete_element_dialog.dart';
import 'vertical_list_element.dart';

class VerticalList extends StatefulWidget {
  final InteractionMain inter;
  final List<elem.Element> elements;
  final List<Widget> widgets;

  const VerticalList(
      {Key? key,
      required this.inter,
      required this.elements,
      required this.widgets})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateElemScreenTemplate();
}

class _StateElemScreenTemplate extends State<VerticalList> {
  InteractionMain get interaction => widget.inter;

  List<elem.Element> get elements => widget.elements;

  List<Widget> get widgets => widget.widgets;

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
              await interaction.updateElemOrder(elements);
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
                      await interaction.deleteItem(
                          'deleteElement', elements[index].id);
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
