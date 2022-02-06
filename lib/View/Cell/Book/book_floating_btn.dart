import 'package:flutter/material.dart';
import '/View/floating_buttons.dart';
import '/Model/Elements/text_type.dart';
import '/View/Interfaces/interaction_to_view_controller.dart';

class BookFloatingBtn extends StatefulWidget {
  final InteractionToViewController interView;

  const BookFloatingBtn({Key? key, required this.interView}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BookFloatingBtn();
}

class _BookFloatingBtn extends State<BookFloatingBtn> {
  get interView => widget.interView;

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(distance: 150.0, children: [
      IconButton(
        onPressed: () async {
          await interView.addTexts(TextType.title.index);
          setState(() {});
        },
        icon: const Icon(Icons.title_rounded),
        iconSize: 45,
      ),
      IconButton(
        onPressed: () async {
          await interView.addTexts(TextType.subtitle.index);
          setState(() {});
        },
        icon: const Icon(Icons.title_rounded),
        iconSize: 40,
      ),
      IconButton(
        onPressed: () async {
          await interView.addTexts(TextType.text.index);
          setState(() {});
        },
        icon: const Icon(Icons.text_fields_rounded),
        iconSize: 45,
      ),
      IconButton(
        onPressed: () async {
          //TODO: If cancel => no setState
          await interView.addImage();
          setState(() {});
        },
        icon: const Icon(Icons.add_photo_alternate_outlined),
        iconSize: 45,
      ),
      IconButton(
        onPressed: () async {
          await interView.addCheckbox();
          setState(() {});
        },
        icon: const Icon(Icons.check_box_rounded),
        iconSize: 45,
      ),
    ]);
  }
}
