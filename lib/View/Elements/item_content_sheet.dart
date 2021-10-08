import 'package:flutter/material.dart';

class ItemContentSheet extends StatefulWidget{
  final Widget widget;
  const ItemContentSheet({required Key key, required this.widget}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _ItemContentSheetState();
}

class _ItemContentSheetState extends State<ItemContentSheet>{
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: const Icon(Icons.delete_outline_rounded)
        ),
        Expanded( child: widget.widget),
      ],
    );
  }
}