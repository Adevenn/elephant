import 'dart:typed_data';

import 'element.dart';

class Image extends Element {
  Uint8List imgPreview;
  Uint8List imgRaw;

  Image(
      {required int id,
      required int idParent,
      required this.imgPreview,
      required this.imgRaw,
      required int idOrder})
      : super(id: id, idParent: idParent, idOrder: idOrder);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'id_sheet': idParent,
        'img_preview': imgPreview,
        'img_raw': imgRaw,
        'elem_order': idOrder,
        'type': runtimeType.toString(),
      };
}
