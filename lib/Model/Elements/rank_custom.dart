import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'element_custom.dart';

class RankCustom extends ElementCustom {
  String title;
  String description;
  Uint8List image;

  RankCustom({required int id,
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
    'img': image,
    'elem_type' : runtimeType.toString()
  };

  @override
  Widget toWidget() {
    // TODO: implement toWidget
    throw UnimplementedError();
  }
}
