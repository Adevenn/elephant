import 'package:flutter/material.dart';
import '../Items/image_preview.dart';
import 'delete_element_dialog.dart';
import '../Interfaces/interaction_to_view_controller.dart';
import '/Model/Elements/checkbox.dart' as cb;
import '/Model/Elements/image.dart' as img;
import '/Model/Elements/text.dart' as text;
import '../Items/checkbox_custom.dart';
import '../Items/text_field_custom.dart';
import 'item_content_sheet.dart';
import '/Model/Elements/element.dart' as elem;

class ItemsScreen extends StatefulWidget{
  final InteractionToViewController interView;

  const ItemsScreen({Key? key, required this.interView}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen>{

  InteractionToViewController get interView => widget.interView;

  List<Widget> elementsToWidgets(List<Object> items, InteractionToViewController interView){
    List<Widget> _widgets = [];
    for(var element in items) {
      switch(element.runtimeType){
        case text.Text:
          _widgets.add(TextFieldCustom(interView: interView, key: UniqueKey(), texts: element as text.Text));
          break;
        case img.Image:
          _widgets.add(ImagePreview(interView: interView, image: element as img.Image, key: UniqueKey()));
          break;
        case cb.Checkbox:
          _widgets.add(CheckboxCustom(interView: interView, key: UniqueKey(), checkbox: element as cb.Checkbox));
          break;
        default:
          throw Exception('Unknown element type');
      }
    }
    return _widgets;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<elem.Element>>(
      future: interView.updateElements(),
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
                    await interView.updateElementsOrder(elements);
                    setState(() {});
                  },
                  children: [
                    for(var index = 0; index < widgets.length; index++)
                      Dismissible(
                        key: UniqueKey(),
                        child: ItemContentSheet(
                          key: UniqueKey(),
                          widget: widgets[index]
                        ),
                        onDismissed: (direction) async{
                          bool result = await showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context)
                              => DeleteElementDialog(elementType: elements[index].runtimeType.toString())
                          );
                          if(result){
                            await interView.deleteElement(elements[index].id);
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