import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../Interfaces/interaction_view.dart';

class ImageCustom extends StatefulWidget{

  final Uint8List data;
  final InteractionView interView;

  const ImageCustom({required this.interView, required this.data, required Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImageState();
}

class _ImageState extends State<ImageCustom>{
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 500,
        maxHeight: 500,
        minWidth: 250,
        minHeight: 250
      ),
      child: Image.memory(widget.data)
    );
  }

}