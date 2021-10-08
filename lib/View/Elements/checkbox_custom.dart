import 'package:flutter/material.dart';
import '../../Model/Elements/checkbox.dart';
import '../interaction_view.dart';

class CheckboxCustom extends StatefulWidget{
  final InteractionView interView;
  final CheckBox checkBox;
  final Key key;

  const CheckboxCustom({required this.interView, required this.key, required this.checkBox});

  @override
  State<StatefulWidget> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckboxCustom>{

  var focusCheckbox = FocusNode();
  var focusTxt = FocusNode();
  late bool backupChecked;
  late String backupText;

  @override
  void initState() {
    super.initState();
    backupChecked = widget.checkBox.isChecked;
    backupText = widget.checkBox.text;
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

 void _updateCheckbox() async{
    if(!focusCheckbox.hasFocus && !focusTxt.hasFocus){
      if(backupChecked != widget.checkBox.isChecked
          || backupText != widget.checkBox.text){
        backupChecked = widget.checkBox.isChecked;
        backupText = widget.checkBox.text;
        widget.interView.updateObject('Checkbox', widget.checkBox.toJson());
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
          value: widget.checkBox.isChecked,
          onChanged: (bool? value){
            setState(() {
              widget.checkBox.isChecked = value!;
              print('isChecked updated');
            });
            focusCheckbox.requestFocus();
          },
        ),
        Expanded(
          child: TextFormField(
            focusNode: focusTxt,
            initialValue: widget.checkBox.text,
            decoration: const InputDecoration(hintText: 'enter some text'),
            onChanged: (value) => widget.checkBox.text = value,
          ),
        ),
      ],
    );
  }
}