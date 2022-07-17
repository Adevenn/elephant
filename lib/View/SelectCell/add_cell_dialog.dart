import 'package:flutter/material.dart';
import '/Model/Cells/cell.dart';

class AddCellDialog extends StatefulWidget {
  final List<Cell> cells;
  final String author;

  const AddCellDialog({Key? key, required this.cells, required this.author})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddCellDialogState();
}

class _AddCellDialogState extends State<AddCellDialog> {
  final _formKey = GlobalKey<FormState>();
  var title = TextEditingController(),
      subtitle = TextEditingController(),
      type = 'Book',
      visibility = 'private';

  bool isCellTitleValid(List<Cell> cells, String title) {
    for (int i = 0; i < cells.length; i++) {
      if (cells[i].title == title) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton(
                    alignment: AlignmentDirectional.center,
                    value: type,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    items: <String>['Book', 'ToDoList', 'Quiz']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        type = newValue!;
                      });
                    }),
                DropdownButton(
                    alignment: AlignmentDirectional.center,
                    value: visibility,
                    items: <String>['public', 'private']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        visibility = newValue!;
                      });
                    })
              ],
            ),
            TextFormField(
                controller: title,
                decoration: const InputDecoration(hintText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  } else if (!isCellTitleValid(widget.cells, value)) {
                    return 'Title already exist';
                  }
                  return null;
                }),
            TextFormField(
              controller: subtitle,
              decoration: const InputDecoration(hintText: 'Subtitle'),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(
                  context,
                  Cell.factory(
                      id: -1,
                      title: title.text,
                      subtitle: subtitle.text,
                      type: type,
                      author: widget.author,
                      isPublic: visibility == 'public' ? true : false));
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
