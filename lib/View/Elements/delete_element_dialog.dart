import 'package:flutter/material.dart';

class DeleteElementDialog extends StatelessWidget{

  final String elementType;

  const DeleteElementDialog({Key? key, required this.elementType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Remove cell'),
      content: Text('Do you really want to remove $elementType ?'),
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