import 'package:flutter/material.dart';
import 'interaction_view.dart';
import 'Elements/item_content_sheet.dart';
import '../../Model/Elements/element.dart' as elem;
import 'tools_view.dart';

class ContentSheet extends StatefulWidget{
  final List<elem.Element> sheetContent;
  final InteractionView interView;

  const ContentSheet({Key? key, required this.sheetContent, required this.interView}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContentSheetState(sheetContent, interView);
}

class _ContentSheetState extends State<ContentSheet>{

  InteractionView interView;
  late List<Widget> _widgets;
  List<elem.Element> elements;

  _ContentSheetState(this.elements, this.interView){
    _widgets = ToolsView.objListToWidgetList(elements, interView);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container()),
        Expanded(
          flex: 5,
          child: ReorderableListView(
            onReorder: (int oldIndex, int newIndex) {
              setState(() {
                if (oldIndex < newIndex){
                  newIndex -= 1;
                }
                elem.Element item = elements.removeAt(oldIndex);
                elements.insert(newIndex, item);
                //TODO: Update idOrder on each element inside the sheet
              });
            },
            children: [
              for(int i = 0; i < _widgets.length; i++)
                Dismissible(
                  key: UniqueKey(),
                  child: ItemContentSheet(
                    key: UniqueKey(),
                    widget: _widgets[i]
                  ),
                  onDismissed: (direction) async{
                    interView.deleteObject(elements[i].runtimeType.toString(), elements[i].id);
                    elements.removeAt(i);
                    //TODO: Update idOrder on each element inside the sheet
                    setState((){});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item deleted'))
                    );
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