import 'package:flutter/material.dart';

class DeleteCellDialog extends StatelessWidget{

  final String cellTitle;

  const DeleteCellDialog({Key? key, required this.cellTitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Remove cell'),
      content: Text('Do you really want to remove $cellTitle ?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Yes'),
        ),
      ],
    );
  }
}