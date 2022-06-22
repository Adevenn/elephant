import 'package:flutter/material.dart';

import '/View/FloatingBtns/animation_floating_btns.dart';
import '/Model/Cells/Book/sheet.dart';
import '../Interfaces/interaction_view.dart';
import '/Network/client.dart';
import '/Model/Elements/image.dart' as img;
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

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    for(int i = 0; i < elements.length; i++){
      switch(elements[i]){
        case 'text':
        case 'subtitle':
        case'title':
          widgets.add(text(elements[i]));
          break;
        case 'image':
          widgets.add(image());
          break;
        case 'checkbox':
          widgets.add(checkbox());
          break;
        default:
          throw Exception();
      }
    }
    return AnimationFloatingBtn(children: widgets);
  }

  Widget checkbox(){
    return IconButton(
      onPressed: () async {
        await addCheckbox(sheet.id);
        onElementAdded();
      },
      icon: const Icon(Icons.check_box_rounded),
      iconSize: 35,
      tooltip: 'Checkbox',
    );
  }

  Widget image() {
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
      tooltip: 'Image',
    );
  }

  Widget text(String type) {
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

  Future<void> addCheckbox(int idSheet) async {
    try {
      await Client.request('addCheckbox', {'id_sheet': idSheet});
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addImage(List<img.Image> images) async {
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
}
