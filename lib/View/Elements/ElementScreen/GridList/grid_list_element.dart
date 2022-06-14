import 'package:flutter/material.dart';

class VerticalListElem extends StatelessWidget {
  final Widget widget;

  const VerticalListElem({required Key key, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: const Icon(Icons.delete_outline_rounded)),
          Expanded(child: widget),
        ],
      ),
    );
  }
}
