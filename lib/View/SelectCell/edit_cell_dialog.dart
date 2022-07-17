import 'package:flutter/material.dart';
import '../../Model/Cells/cell.dart';

class EditCellDialog extends StatefulWidget {
  final List<Cell> cells;
  final String title, subtitle, type, author, visibility;
  final int id;

  const EditCellDialog(
      {Key? key,
      required this.cells,
      required this.id,
      required this.title,
      required this.subtitle,
      required this.type,
      required this.author,
      required this.visibility})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditCellDialogState();
}

class _EditCellDialogState extends State<EditCellDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController title, subtitle;
  late String type, visibility;

  bool isCellTitleValid(List<Cell> cells, String title) {
    for (int i = 0; i < cells.length; i++) {
      if (cells[i].title == title && title != widget.title) {
        return false;
      }
    }
    return true;
  }

  @override
  void initState() {
    title = TextEditingController(text: widget.title);
    subtitle = TextEditingController(text: widget.subtitle);
    type = widget.type;
    visibility = widget.visibility;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cell edit'),
      scrollable: true,
      content: Form(
        key: _formKey,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(type),
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
                      id: widget.id,
                      title: title.text,
                      subtitle: subtitle.text,
                      type: type,
                      author: widget.author,
                      isPublic: visibility == 'public' ? true : false));
            }
          },
          child: const Text('Edit'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        )
      ],
    );
  }
}
