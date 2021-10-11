import 'package:flutter/material.dart';
import 'package:my_netia_client/View/interaction_to_main_screen.dart';
import '../Model/Elements/checkbox.dart';
import '../Model/Elements/images.dart';
import '../Model/Elements/texts.dart';
import 'Elements/checkbox_custom.dart';
import 'Elements/text_field_custom.dart';
import 'interaction_view.dart';
import 'Elements/item_content_sheet.dart';
import '../Model/Elements/element.dart' as elem;

class ContentSheet extends StatefulWidget{
  final List<elem.Element> sheetContent;
  final InteractionView interView;
  final InteractionToMainScreen interMain;

  const ContentSheet({Key? key, required this.sheetContent, required this.interView, required this.interMain}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ContentSheetState();
}

class _ContentSheetState extends State<ContentSheet>{

  InteractionToMainScreen get interMain => widget.interMain;
  InteractionView get interView => widget.interView;
  late final List<Widget> _widgets = elementsToWidgets(elements, interView);
  List<elem.Element> get elements => widget.sheetContent;

  List<Widget> elementsToWidgets(List<Object> items, InteractionView interView){
    List<Widget> _widgets = [];
    for(var element in items) {
      switch(element.runtimeType){
        case Texts:
          _widgets.add(TextFieldCustom(interView: interView, key: UniqueKey(), texts: element as Texts));
          break;
        case Images:
          print("IMAGE TYPE");
          break;
        case CheckBox:
          _widgets.add(CheckboxCustom(interView: interView, key: UniqueKey(), checkBox: element as CheckBox));
          break;
        default:
          throw Exception("Unknown element type");
      }
    }
    return _widgets;
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
                    await interMain.deleteElement(elements[i].runtimeType.toString(), elements[i].id);
                    //TODO: Update idOrder on each element inside the sheet
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