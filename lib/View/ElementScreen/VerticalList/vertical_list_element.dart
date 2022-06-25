import 'package:flutter/material.dart';

class VerticalListElem extends StatelessWidget {
  final Widget widget;

  const VerticalListElem({required Key key, required this.widget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: widget,
    );
  }
}
