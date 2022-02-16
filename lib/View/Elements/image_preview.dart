import 'package:flutter/material.dart';
import '../Interfaces/interaction_main.dart';
import '/Model/Elements/image.dart' as img;
import '../Elements/ImageZoom/image_screen.dart';

class ImagePreview extends StatelessWidget{

  final img.Image image;
  final InteractionMain interMain;

  const ImagePreview({required this.interMain, required this.image, required Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
      child: InkWell(
        child: Image.memory(image.imgPreview),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ImageScreen(idImage: image.id, interMain: interMain))),
      ),
    );
  }
}