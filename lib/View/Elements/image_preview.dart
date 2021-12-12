import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../Interfaces/interaction_view.dart';

class ImagePreview extends StatelessWidget{

  final Uint8List data;
  final InteractionView interView;

  const ImagePreview({required this.interView, required this.data, required Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints(
          maxWidth: 500,
          maxHeight: 500
        ),
        child: Image.memory(data)
    );
  }
}