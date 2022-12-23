import 'dart:io';

import 'package:elephant_client/Model/Cells/page_custom.dart';
import 'package:elephant_client/Model/Elements/image_custom.dart';
import 'package:elephant_client/Model/Elements/text_type.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_compression/image_compression.dart';

import 'animation_floating_btns.dart';

class FloatingButtons extends StatelessWidget {
  final PageCustom page;
  final List<String> elementsType;
  final VoidCallback onElementAdded;

  const FloatingButtons(
      {Key? key,
      required this.elementsType,
      required this.page,
      required this.onElementAdded})
      : super(key: key);

  Future<List<ImageCustom>> pickImage() async {
    var images = <ImageCustom>[];
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.image,
        dialogTitle: 'elephant image selection');
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      for (var file in files) {
        var image =
            ImageFile(filePath: file.path, rawBytes: file.readAsBytesSync());
        var imageCompressed = compress(ImageFileConfiguration(
            input: image,
            config: const Configuration(
                pngCompression: PngCompression.bestCompression,
                jpgQuality: 25)));
        images.add(ImageCustom(
            id: -1,
            imgPreview: imageCompressed.rawBytes,
            imgRaw: image.rawBytes,
            idPage: page.id,
            idOrder: -1));
      }
    }
    return images;
  }

  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];
    for (int i = 0; i < elementsType.length; i++) {
      switch (elementsType[i]) {
        case 'text':
        case 'subtitle':
        case 'title':
          widgets.add(textBtn(elementsType[i]));
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
        await page.addCheckbox();
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
        var list = await pickImage();
        if (list.isNotEmpty) {
          await page.addImage(list);
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
        await page.addTexts(selectTextType(type));
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
        await page.addFlashcard();
        onElementAdded();
      },
      icon: const Icon(Icons.credit_card_rounded),
      iconSize: 35,
      tooltip: 'flashcard',
    );
  }
}
