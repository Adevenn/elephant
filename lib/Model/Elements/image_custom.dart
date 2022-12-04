import 'dart:typed_data';
import 'package:flutter/material.dart';

import '/View/Cell/image_screen.dart';
import '/Network/client.dart';
import 'element_custom.dart';

class ImageCustom extends ElementCustom {
  List<int> imgPreview, imgRaw;

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
        'elem_type': runtimeType.toString(),
      };

  Widget toImageRaw() => ImageRaw(data: Uint8List.fromList(imgRaw));

  @override
  Widget toWidget() => _ImagePreview(image: this, key: UniqueKey());

  Future<Uint8List> getRawImage() async {
    try {
      var result = await Client.requestResult('rawImage', {'id_img': id});
      imgRaw = result['image_raw'].cast<int>();
      return Uint8List.fromList(imgRaw);
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
        child: Image.memory(Uint8List.fromList(image.imgPreview)),
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
