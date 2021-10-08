import 'package:flutter/material.dart';
import '../interaction_view.dart';
import '../../Model/Elements/texts.dart';
import '../../Model/Elements/text_type.dart';

class TextFieldCustom extends StatefulWidget{
  final InteractionView interView;
  final Texts texts;
  final Key key;

  const TextFieldCustom({required this.interView, required this.key, required this.texts});

  @override
  State<StatefulWidget> createState() => _TextFieldCustomState();
}

class _TextFieldCustomState extends State<TextFieldCustom>{

  final focus = FocusNode();
  late String backupText;

  @override
  void initState() {
    super.initState();
    backupText = widget.texts.text;
    focus.addListener(_updateTexts);
  }

  @override
  void dispose() {
    super.dispose();
    focus.removeListener(_updateTexts);
    focus.dispose();
  }

  void _updateTexts() {
    if(backupText != widget.texts.text){
      widget.interView.updateObject('Texts', widget.texts.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    switch(widget.texts.txtType){
      case TextType.text:
        return TextFormField(
          focusNode: focus,
          keyboardType: TextInputType.multiline,
          minLines: 1,
          maxLines: 50,
          initialValue: widget.texts.text,
          decoration: const InputDecoration(hintText: "enter some text"),
          onChanged: (value) => widget.texts.text = value,
        );
      case TextType.subtitle:
        return TextFormField(
          focusNode: focus,
          style: const TextStyle(
            fontSize: 19,
            fontStyle: FontStyle.italic
          ),
          initialValue: widget.texts.text,
          decoration: const InputDecoration(hintText: "enter some text"),
          onChanged: (value) => widget.texts.text = value,
        );
      case TextType.title:
        return TextFormField(
          focusNode: focus,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold
          ),
          initialValue: widget.texts.text,
          decoration: const InputDecoration(hintText: "enter some text"),
          onChanged: (value) => widget.texts.text = value,
        );
      case TextType.readonly:
        return Container(
          margin: const EdgeInsets.all(5),
          child: Text(
            widget.texts.text,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18),
          ),
        );
      default:
        throw Exception("UNKNOWN TEXT TYPE");
    }
  }
}