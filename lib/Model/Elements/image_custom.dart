import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '/View/image_screen.dart';
import '/Network/client.dart';
import 'element_custom.dart';

class ImageCustom extends ElementCustom {
  Uint8List imgPreview;
  Uint8List imgRaw;

  ImageCustom(
      {required int id,
      required int idParent,
      required this.imgPreview,
      required this.imgRaw,
      required int idOrder})
      : super(id: id, idSheet: idParent, idOrder: idOrder);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'id_sheet': idSheet,
        'img_preview': imgPreview,
        'img_raw': imgRaw,
        'elem_order': idOrder,
        'type': runtimeType.toString(),
      };

  Widget toImageRaw() => ImageRaw(data: imgRaw);

  @override
  Widget toWidget() => _ImagePreview(image: this, key: UniqueKey());

  Future<Uint8List> getRawImage() async {
    try {
      var result = await Client.requestResult('rawImage', {'id_img': id});
      var imgRawJson = jsonDecode(result);
      imgRaw =  Uint8List.fromList(imgRawJson['img_raw'].cast<int>());
      return imgRaw;
    } catch (e) {
      throw Exception(e);
    }
  }
}

class _ImagePreview extends StatelessWidget {
  final ImageCustom image;

  const _ImagePreview({required this.image, required Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 500, maxHeight: 500),
      child: InkWell(
        child: Image.memory(image.imgPreview),
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => ImageScreen(image: image))),
      ),
    );
  }
}

class ImageRaw extends StatelessWidget {
  final Uint8List data;

  const ImageRaw({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(child: Image.memory(data));
  }
}
