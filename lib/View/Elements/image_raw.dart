import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageRaw extends StatelessWidget{

  final Uint8List data;

  const ImageRaw({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Image.memory(data)
    );
  }
}