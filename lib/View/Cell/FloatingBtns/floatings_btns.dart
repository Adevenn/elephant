import 'package:flutter/material.dart';

import 'animation_floating_btns.dart';
import '/Model/Cells/sheet.dart';
import '/View/Interfaces/interaction_view.dart';
import '/Network/client.dart';
import '/Model/Elements/image_custom.dart';
import '/Model/Elements/text_type.dart';

class FloatingButtons extends StatelessWidget {
  final Sheet sheet;
  final List<String> elements;
  final InteractionView interView;
  final VoidCallback onElementAdded;

  const FloatingButtons(
      {Key? key,
      required this.elements,
      required this.sheet,
      required this.interView,
      required this.onElementAdded})
      : super(key: key);

  Future<void> addCheckbox(int idSheet) async {
    try {
      await Client.request('addCheckbox', {'id_sheet': idSheet});
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addImage(List<ImageCustom> images) async {
    try {
      for (var image in images) {
        await Client.request('addImage', {
          'id_sheet': image.idSheet,
          'img_preview': image.imgPreview,
          'img_raw': image.imgRaw
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addTexts(int idSheet, int txtType) async {
    try {
      await Client.request(
          'addText', {'id_sheet': idSheet, 'txt_type': txtType});
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addFlashcard(int idSheet) async {
    try {
      await Client.request('addFlashcard', {'id_sheet': idSheet});
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    for (int i = 0; i < elements.length; i++) {
      switch (elements[i]) {
        case 'text':
        case 'subtitle':
        case 'title':
          widgets.add(textBtn(elements[i]));
          break;
        case 'image':
          widgets.add(imageBtn());
          break;
        case 'checkbox':
          widgets.add(checkboxBtn());
          break;
        case 'flashcard':
          widgets.add(flashcardBtn());
          break;
        default:
          throw Exception();
      }
    }
    return AnimationFloatingBtn(children: widgets);
  }

  Widget checkboxBtn() {
    return IconButton(
      onPressed: () async {
        await addCheckbox(sheet.id);
        onElementAdded();
      },
      icon: const Icon(Icons.check_box_rounded),
      iconSize: 35,
      tooltip: 'checkbox',
    );
  }

  Widget imageBtn() {
    return IconButton(
      onPressed: () async {
        var list = await interView.pickImage(sheet);
        if (list.isNotEmpty) {
          await addImage(list);
          onElementAdded();
        }
      },
      icon: const Icon(Icons.add_photo_alternate_outlined),
      iconSize: 35,
      tooltip: 'image',
    );
  }

  Widget textBtn(String type) {
    return IconButton(
      onPressed: () async {
        await addTexts(sheet.id, selectTextType(type));
        onElementAdded();
      },
      icon: const Icon(Icons.title_rounded),
      iconSize: 35,
      tooltip: type,
    );
  }

  int selectTextType(String type) {
    switch (type) {
      case 'text':
        return TextType.text.index;
      case 'subtitle':
        return TextType.subtitle.index;
      case 'title':
        return TextType.title.index;
      case 'readonly':
        return TextType.readonly.index;
      default:
        throw Exception("This text type doesn't exist : $type");
    }
  }

  Widget flashcardBtn() {
    return IconButton(
      onPressed: () async {
        await addFlashcard(sheet.id);
        onElementAdded();
      },
      icon: const Icon(Icons.credit_card_rounded),
      iconSize: 35,
      tooltip: 'flashcard',
    );
  }
}
