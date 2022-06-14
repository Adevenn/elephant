import 'dart:typed_data';

import '/Model/Elements/element.dart';

class Rank extends Element {
  String title;
  String description;
  Uint8List image;

  Rank({required int id,
    required int idParent,
    required int idOrder,
    required this.title,
    required this.image,
    this.description = ''
  }) : super(id: id, idSheet: idParent, idOrder: idOrder);

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'id_sheet': idSheet,
    'elem_order': idOrder,
    'title': title,
    'description': description,
    'img': image
  };
}
