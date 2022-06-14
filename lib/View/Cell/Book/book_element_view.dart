import 'package:flutter/material.dart';
import '/View/Interfaces/interaction_view.dart';
import '/View/Interfaces/interaction_main.dart';
import '../../Elements/ElementScreen/VerticalList/vertical_list.dart';
import '/View/loading_screen.dart';
import '/Model/Elements/text_type.dart';
import '/View/floating_buttons.dart';
import '/Model/Cells/Book/sheet.dart';
import '/Model/Elements/element.dart' as elem;

class BookElemView extends StatefulWidget {
  final InteractionMain interMain;
  final InteractionView interView;
  final Sheet sheet;

  const BookElemView(
      {Key? key,
      required this.interMain,
      required this.interView,
      required this.sheet})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _StateBookElemView();
}

class _StateBookElemView extends State<BookElemView> {
  InteractionMain get interMain => widget.interMain;

  InteractionView get interView => widget.interView;

  Sheet get sheet => widget.sheet;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<elem.Element>>(
        future: interMain.getElements(sheet.id),
        builder:
            (BuildContext context, AsyncSnapshot<List<elem.Element>> snapshot) {
          if (snapshot.hasData) {
            var elements = snapshot.data!;
            var widgets = interView.elementsToWidgets(elements, interView);

            return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Column(
                              children: [
                                Text(
                                  sheet.title,
                                  style: const TextStyle(
                                      fontSize: 30,
                                      fontStyle: FontStyle.normal),
                                ),
                                Text(
                                  sheet.subtitle,
                                  style: const TextStyle(
                                      fontSize: 25,
                                      fontStyle: FontStyle.italic),
                                )
                              ],
                            ))
                          ],
                        ),
                      ),
                      Expanded(
                        child: VerticalList(
                            inter: interMain,
                            elements: elements,
                            widgets: widgets),
                      )
                    ],
                  ),
                ),
                floatingActionButton: floatingBtn());
          } else {
            return const LoadingScreen();
          }
        });
  }

  Widget floatingBtn() => ExpandableFab(distance: 150.0, children: [
        IconButton(
          onPressed: () async {
            await interMain.addTexts(sheet.id, TextType.text.index);
            setState(() {});
          },
          icon: const Icon(Icons.title_rounded),
          iconSize: 35,
          tooltip: 'Text',
        ),
        IconButton(
          onPressed: () async {
            await interMain.addTexts(sheet.id, TextType.subtitle.index);
            setState(() {});
          },
          icon: const Icon(Icons.text_fields_rounded),
          iconSize: 30,
          tooltip: 'Subtitle',
        ),
        IconButton(
          onPressed: () async {
            await interMain.addTexts(sheet.id, TextType.title.index);
            setState(() {});
          },
          icon: const Icon(Icons.text_fields_rounded),
          iconSize: 35,
          tooltip: 'Title',
        ),
        IconButton(
          onPressed: () async {
            var list = await interView.pickImage(sheet);
            if (list.isNotEmpty) {
              await interMain.addImage(list);
              setState(() {});
            }
          },
          icon: const Icon(Icons.add_photo_alternate_outlined),
          iconSize: 35,
          tooltip: 'Image',
        ),
        IconButton(
          onPressed: () async {
            await interMain.addCheckbox(sheet.id);
            setState(() {});
          },
          icon: const Icon(Icons.check_box_rounded),
          iconSize: 35,
          tooltip: 'Checkbox',
        ),
      ]);
}
