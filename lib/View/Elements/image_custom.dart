import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageCustom extends StatefulWidget{
  final Uint8List data;
  const ImageCustom(this.data, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ImageState();
}

class _ImageState extends State<ImageCustom>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}