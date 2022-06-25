import 'package:flutter/material.dart';

class DeleteSheetDialog extends StatelessWidget {
  final String sheetTitle;

  const DeleteSheetDialog({Key? key, required this.sheetTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Remove sheet'),
      content: Text('Do you really want to delete $sheetTitle ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Yes'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        )
      ],
    );
  }
}
