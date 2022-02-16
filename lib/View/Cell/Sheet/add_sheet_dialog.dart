import 'package:flutter/material.dart';
import '../../../../Model/Cells/Book/sheet.dart';

class AddSheetDialog extends StatelessWidget{

  final List<Sheet> sheets;

  const AddSheetDialog({Key? key, required this.sheets}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _formKey = GlobalKey<FormState>();
    var _title = TextEditingController();
    var _subtitle = TextEditingController();

    bool isSheetTitleValid(List<Sheet> sheets, String title){
      for(int i = 0; i < sheets.length; i++){
        if(sheets[i].title == title){
          return false;
        }
      }
      return true;
    }

    return AlertDialog(
      title: const Text('Add Sheet'),
      scrollable: true,
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(hintText: 'Title'),
              validator: (value){
                if(value == null || value.isEmpty) {
                  return 'Please enter some text';
                } else if (!isSheetTitleValid(sheets, value)) {
                  return 'Title already exist';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _subtitle,
              decoration: const InputDecoration(hintText: 'Subtitle'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: (){
            if(_formKey.currentState!.validate()){
              List<String> sheet = [_title.text, _subtitle.text];
              Navigator.pop(context, sheet);
            }
          },
          child: const Text('Add'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        )
      ],
    );
  }
}