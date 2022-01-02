import 'package:flutter/material.dart';
import '/Model/cell.dart';

class AddCellDialog extends StatefulWidget{

  final List<Cell> cells;

  const AddCellDialog({Key? key, required this.cells}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddCellDialogState();

}

class _AddCellDialogState extends State<AddCellDialog>{

  final _formKey = GlobalKey<FormState>();
  var title = TextEditingController();
  var subtitle = TextEditingController();
  String type = "Book";

  bool isCellTitleValid(List<Cell> cells, String title){
    for(int i = 0; i < cells.length; i++){
      if(cells[i].title == title){
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add cell'),
      scrollable: true,
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            DropdownButton(
              value: type,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: <String>['Book', 'ToDoList', 'Ranking'].map<DropdownMenuItem<String>>((String value){
                return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value)
                );
              }).toList(),
              onChanged: (String? newValue) => (() => type = newValue!)
            ),
            TextFormField(
              controller: title,
              decoration: const InputDecoration(hintText: 'Title'),
              validator: (value){
                if(value == null || value.isEmpty) {
                  return 'Please enter some text';
                } else if (!isCellTitleValid(widget.cells, value)) {
                  return 'Title already exist';
                }
                return null;
              }
            ),
            TextFormField(
              controller: subtitle,
              decoration: const InputDecoration(hintText: 'Subtitle'),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: (){
            if(_formKey.currentState!.validate()){
              List<String> list = [title.text, subtitle.text, type];
              Navigator.pop(context, list);
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