import 'package:flutter/material.dart';
import 'package:my_netia_client/Controller/controller.dart';
import 'package:my_netia_client/Model/Elements/text_type.dart';
import '../../floating_buttons.dart';
import '/Model/sheet.dart';
import '../delete_element_dialog.dart';
import '../element_template.dart';
import '/View/Interfaces/interaction_to_view_controller.dart';
import '/Model/Elements/element.dart' as elem;
import 'book_floating_btn.dart';

class BookElemView extends StatefulWidget {
  final InteractionToViewController interView;
  final Sheet sheet;

  const BookElemView({Key? key, required this.interView, required this.sheet})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateBookElemView();
}

class _StateBookElemView extends State<BookElemView> {
  get interView => widget.interView;

  get sheet => widget.sheet;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<elem.Element>>(
        future: interView.updateElements(sheet),
        builder:
            (BuildContext context, AsyncSnapshot<List<elem.Element>> snapshot) {
          if (snapshot.hasData) {
            var elements = snapshot.data!;
            var widgets = interView.elementsToWidgets(elements, interView);

            return Scaffold(
                body: Row(
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
                              child: ElemTemplate(
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
                                  await interView
                                      .deleteElement(elements[index].id);
                                }
                                setState(() {});
                              },
                              background:
                                  Container(color: const Color(0xBCC11717)),
                            )
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                  ],
                ),
                floatingActionButton: floatingBtn());
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

  Widget floatingBtn() => ExpandableFab(distance: 150.0, children: [
        IconButton(
          onPressed: () async {
            await interView.addTexts(sheet, TextType.text.index);
            setState(() {});
          },
          icon: const Icon(Icons.title_rounded),
          iconSize: 35,
          tooltip: 'Text',
        ),
        IconButton(
          onPressed: () async {
            await interView.addTexts(sheet, TextType.subtitle.index);
            setState(() {});
          },
          icon: const Icon(Icons.text_fields_rounded),
          iconSize: 30,
          tooltip: 'Subtitle',
        ),
        IconButton(
          onPressed: () async {
            await interView.addTexts(sheet, TextType.title.index);
            setState(() {});
          },
          icon: const Icon(Icons.text_fields_rounded),
          iconSize: 35,
          tooltip: 'Title',
        ),
        IconButton(
          onPressed: () async {
            //TODO: If cancel => no setState
            await interView.addImage(sheet);
            setState(() {});
          },
          icon: const Icon(Icons.add_photo_alternate_outlined),
          iconSize: 35,
          tooltip: 'Image',
        ),
        IconButton(
          onPressed: () async {
            await interView.addCheckbox(sheet);
            setState(() {});
          },
          icon: const Icon(Icons.check_box_rounded),
          iconSize: 35,
          tooltip: 'Checkbox',
        ),
      ]);
}
