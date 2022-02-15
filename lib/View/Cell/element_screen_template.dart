import 'package:flutter/material.dart';
import '/Model/Elements/element.dart' as elem;
import '/View/Interfaces/interaction_to_view_controller.dart';
import 'delete_element_dialog.dart';
import 'element_template.dart';

class ElemScreenTemplate extends StatefulWidget {
  final InteractionToViewController interView;
  final List<elem.Element> elements;
  final List<Widget> widgets;

  const ElemScreenTemplate(
      {Key? key,
      required this.interView,
      required this.elements,
      required this.widgets})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateElemScreenTemplate();
}

class _StateElemScreenTemplate extends State<ElemScreenTemplate> {
  InteractionToViewController get interView => widget.interView;

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
              await interView.updateOrder('Element', elements);
              setState(() {});
            },
            children: [
              for (var index = 0; index < widgets.length; index++)
                Dismissible(
                  key: UniqueKey(),
                  child: ElemTemplate(key: UniqueKey(), widget: widgets[index]),
                  onDismissed: (direction) async {
                    bool result = await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) => DeleteElementDialog(
                            elementType:
                                elements[index].runtimeType.toString()));
                    if (result) {
                      await interView.deleteElement(elements[index].id);
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
