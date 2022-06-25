import 'package:flutter/material.dart';

import '/Network/client.dart';
import 'element_custom.dart';

class CheckboxCustom extends ElementCustom{
  bool isChecked;
  String text;

  CheckboxCustom({this.isChecked = false, required this.text, required int id, required int idSheet, required int idOrder})
    : super(id: id, idSheet: idSheet, idOrder: idOrder);

  @override
  Map<String, dynamic> toJson() => {
    'id' : id,
    'id_sheet' : idSheet,
    'is_checked' : isChecked,
    'text' : text,
    'elem_order' : idOrder,
    'type' : runtimeType.toString(),
  };

  @override
  Widget toWidget() => _CheckboxCustomView(key: UniqueKey(), checkbox: this);
}


/// VIEW PART ///

class _CheckboxCustomView extends StatefulWidget {
  final CheckboxCustom checkbox;

  const _CheckboxCustomView({required Key key, required this.checkbox})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<_CheckboxCustomView> {
  CheckboxCustom get checkbox => widget.checkbox;

  var focusCheckbox = FocusNode();
  var focusTxt = FocusNode();
  late bool backupChecked;
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
    backupChecked = checkbox.isChecked;
    backupText = checkbox.text;
    focusTxt.addListener(_updateCheckbox);
    focusCheckbox.addListener(_updateCheckbox);
  }

  @override
  void dispose() {
    super.dispose();
    focusCheckbox.removeListener(_updateCheckbox);
    focusTxt.removeListener(_updateCheckbox);
    focusCheckbox.dispose();
    focusTxt.dispose();
  }

  ///Update [checkbox] when values change and both elements
  ///([checkbox.text] and [checkbox.isChecked]) lost focus
  void _updateCheckbox() async {
    if (!focusCheckbox.hasFocus && !focusTxt.hasFocus) {
      if (backupChecked != checkbox.isChecked || backupText != checkbox.text) {
        backupChecked = checkbox.isChecked;
        backupText = checkbox.text;
        updateItem('updateCheckbox', checkbox.toJson());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
          focusNode: focusCheckbox,
          value: checkbox.isChecked,
          onChanged: (bool? value) {
            focusCheckbox.requestFocus();
            setState(() => checkbox.isChecked = value!);
          },
        ),
        Expanded(
          child: TextFormField(
            focusNode: focusTxt,
            initialValue: checkbox.text,
            decoration: const InputDecoration(hintText: 'enter some text'),
            onChanged: (value) => checkbox.text = value,
          ),
        ),
      ],
    );
  }
}
