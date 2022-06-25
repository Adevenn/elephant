import 'dart:typed_data';
import 'package:flutter/material.dart';

import '/Model/Elements/rank_custom.dart';
import 'checkbox_custom.dart';
import 'image_custom.dart';
import 'text_custom.dart';
import 'text_type.dart';

abstract class ElementCustom {
  final int id;
  final int idSheet;
  int idOrder;

  ElementCustom({required this.id, required this.idSheet, required this.idOrder});

  factory ElementCustom.fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case 'CheckboxCustom':
        return CheckboxCustom(
            id: json['id'],
            idSheet: json['id_sheet'],
            isChecked: json['is_checked'],
            text: json['text'],
            idOrder: json['elem_order']);
      case 'ImageCustom':
        return ImageCustom(
            id: json['id'],
            idParent: json['id_sheet'],
            imgPreview: Uint8List.fromList(json['img_preview'].cast<int>()),
            imgRaw: Uint8List.fromList(json['img_raw'].cast<int>()),
            idOrder: json['elem_order']);
      case 'TextCustom':
        return TextCustom(
            id: json['id'],
            idParent: json['id_sheet'],
            text: json['text'],
            txtType: TextType.values[json['txt_type']],
            idOrder: json['elem_order']);
      case 'RankCustom':
        return RankCustom(
            id: json['id'],
            idParent: json['id_sheet'],
            title: json['title'],
            description: json['description'],
            image: Uint8List.fromList(json['img'].cast<int>()),
            idOrder: json['elem_order']);
      default:
        throw Exception('Json with wrong element type');
    }
  }

  Map<String, dynamic> toJson();

  Widget toWidget();
}
