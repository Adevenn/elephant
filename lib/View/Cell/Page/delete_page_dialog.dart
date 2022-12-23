import 'package:flutter/material.dart';

class DeletePageDialog extends StatelessWidget {
  final String pageTitle;

  const DeletePageDialog({Key? key, required this.pageTitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Remove page'),
      content: Text('Do you really want to delete $pageTitle ?'),
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
