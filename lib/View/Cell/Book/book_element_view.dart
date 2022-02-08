import 'package:flutter/material.dart';
import '/View/Cell/element_screen_template.dart';
import '/View/loading_screen.dart';
import '/Model/Elements/text_type.dart';
import '../../floating_buttons.dart';
import '/Model/sheet.dart';
import '/View/Interfaces/interaction_to_view_controller.dart';
import '/Model/Elements/element.dart' as elem;

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
                body: ElemScreenTemplate(
                    interView: interView, elements: elements, widgets: widgets),
                floatingActionButton: floatingBtn());
          } else {
            return const LoadingScreen();
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
