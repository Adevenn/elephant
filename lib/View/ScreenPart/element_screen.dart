import 'package:flutter/material.dart';
import 'package:my_netia_client/View/Screens/main_screen.dart';
import '../Interfaces/interaction_to_main_screen.dart';
import '/Model/Elements/checkbox.dart';
import '/Model/Elements/images.dart';
import '/Model/Elements/texts.dart';
import '../Elements/checkbox_custom.dart';
import '../Elements/text_field_custom.dart';
import '../Interfaces/interaction_view.dart';
import '../Elements/item_content_sheet.dart';
import '/Model/Elements/element.dart' as elem;

class ElementScreen extends StatefulWidget{
  final InteractionView interView;
  final InteractionToMainScreen interMain;

  const ElementScreen({Key? key, required this.interView, required this.interMain}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ElementScreenState();
}

class _ElementScreenState extends State<ElementScreen>{

  InteractionToMainScreen get interMain => widget.interMain;
  InteractionView get interView => widget.interView;

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
          _widgets.add(CheckboxCustom(interView: interView, key: UniqueKey(), checkbox: element as CheckBox));
          break;
        default:
          throw Exception("Unknown element type");
      }
    }
    return _widgets;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<elem.Element>>(
      future: interMain.updateElements(),
      builder: (BuildContext context, AsyncSnapshot<List<elem.Element>> snapshot){
        if(snapshot.hasData){
          var elements = snapshot.data!;
          var widgets = elementsToWidgets(elements, interView);
          return Row(
            children: [
              Expanded(child: Container()),
              Expanded(
                flex: 5,
                child: ReorderableListView(
                  onReorder: (int oldIndex, int newIndex) async{
                    if (oldIndex < newIndex){
                      newIndex -= 1;
                    }
                    elem.Element item = elements.removeAt(oldIndex);
                    elements.insert(newIndex, item);
                    await interMain.updateElementsOrder(elements);
                    setState(() {});
                  },
                  children: [
                    for(var i = 0; i < widgets.length; i++)
                      Dismissible(
                        key: UniqueKey(),
                        child: ItemContentSheet(
                          key: UniqueKey(),
                          widget: widgets[i]
                        ),
                        onDismissed: (direction) async{
                          await interMain.deleteElement(elements[i].id);
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
        else{
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
                SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Text('Awaiting ...'),
                )
              ],
            ),
          );
        }
      }
    );
  }
}