import 'package:flutter/material.dart';

import '/Network/client.dart';
import 'element_custom.dart';
import 'text_type.dart';

class TextCustom extends ElementCustom {
  String text;
  late TextType txtType;

  TextCustom(
      {required this.text,
      required this.txtType,
      required int id,
      required int idParent,
      required int idOrder})
      : super(id: id, idSheet: idParent, idOrder: idOrder);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'id_sheet': idSheet,
        'txt_text': text,
        'txt_type': txtType.index,
        'elem_order': idOrder,
        'elem_type': runtimeType.toString(),
      };

  @override
  Widget toWidget() => _TextFieldCustom(key: UniqueKey(), texts: this);
}

class _TextFieldCustom extends StatefulWidget {
  final TextCustom texts;

  const _TextFieldCustom({required Key? key, required this.texts})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<_TextFieldCustom> {
  TextCustom get texts => widget.texts;
  final focus = FocusNode();
  late String backupText;

  Future<void> updateItem(String request, Map<String, dynamic> json) async {
    try {
      await Client.request(request, json);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    backupText = texts.text;
    focus.addListener(_updateTexts);
  }

  @override
  void dispose() {
    super.dispose();
    focus.removeListener(_updateTexts);
    focus.dispose();
  }

  void _updateTexts() {
    if (backupText != texts.text) {
      updateItem('updateText', texts.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (texts.txtType) {
      case TextType.text:
        return TextFormField(
          focusNode: focus,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 50,
          initialValue: texts.text,
          decoration: const InputDecoration(hintText: 'enter some text'),
          onChanged: (value) => texts.text = value,
        );
      case TextType.subtitle:
        return TextFormField(
          focusNode: focus,
          style: const TextStyle(fontSize: 19, fontStyle: FontStyle.italic),
          initialValue: texts.text,
          decoration: const InputDecoration(hintText: 'enter some text'),
          onChanged: (value) => texts.text = value,
        );
      case TextType.title:
        return TextFormField(
          focusNode: focus,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          initialValue: texts.text,
          decoration: const InputDecoration(hintText: 'enter some text'),
          onChanged: (value) => texts.text = value,
        );
      case TextType.readonly:
        return Container(
          margin: const EdgeInsets.all(5),
          child: Text(
            texts.text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        );
      default:
        throw Exception('Unknown text type');
    }
  }
}
