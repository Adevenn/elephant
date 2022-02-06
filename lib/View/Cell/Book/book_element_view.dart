import 'package:flutter/material.dart';
import '/View/Elements/delete_element_dialog.dart';
import '/View/Elements/item_content_sheet.dart';
import '/Model/cell.dart';
import '/View/Interfaces/interaction_to_view_controller.dart';
import '/Model/Elements/element.dart' as elem;

class BookElemView extends StatefulWidget {
  final InteractionToViewController interView;
  final Cell cell;

  const BookElemView({Key? key, required this.interView, required this.cell})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateBookElemView();
}

class _StateBookElemView extends State<BookElemView> {
  get interView => widget.interView;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<elem.Element>>(
        future: interView.updateElements(),
        builder:
            (BuildContext context, AsyncSnapshot<List<elem.Element>> snapshot) {
          if (snapshot.hasData) {
            var elements = snapshot.data!;
            var widgets = interView.elementsToWidgets(elements, interView);
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
                      elements.insert(newIndex, item);
                      await interView.updateElementsOrder(elements);
                      setState(() {});
                    },
                    children: [
                      for (var index = 0; index < widgets.length; index++)
                        Dismissible(
                          key: UniqueKey(),
                          child: ItemContentSheet(
                              key: UniqueKey(), widget: widgets[index]),
                          onDismissed: (direction) async {
                            bool result = await showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) =>
                                    DeleteElementDialog(
                                        elementType: elements[index]
                                            .runtimeType
                                            .toString()));
                            if (result) {
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
          } else {
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
        });
  }
}
