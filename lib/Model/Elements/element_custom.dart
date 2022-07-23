import 'package:flutter/material.dart';

import 'flashcard_custom.dart';
import 'rank_custom.dart';
import 'checkbox_custom.dart';
import 'image_custom.dart';
import 'text_custom.dart';
import 'text_type.dart';

abstract class ElementCustom {
  final int id;
  final int idSheet;
  int idOrder;

  ElementCustom(
      {required this.id, required this.idSheet, required this.idOrder});

  factory ElementCustom.fromJson(Map<String, dynamic> json) {
    switch (json['elem_type'] as String) {
      case 'CheckboxCustom':
        return CheckboxCustom(
            id: json['id'],
            idSheet: json['id_sheet'],
            isChecked: json['is_checked'],
            text: json['cb_text'],
            idOrder: json['elem_order']);
      case 'ImageCustom':
        return ImageCustom(
            id: json['id'],
            idParent: json['id_sheet'],
            imgPreview: json['img_preview'].cast<int>(),
            imgRaw: json['img_raw'].cast<int>(),
            idOrder: json['elem_order']);
      case 'TextCustom':
        return TextCustom(
            id: json['id'],
            idParent: json['id_sheet'],
            text: json['txt_text'],
            txtType: TextType.values[json['txt_type']],
            idOrder: json['elem_order']);
      case 'RankCustom':
        return RankCustom(
            id: json['id'],
            idParent: json['id_sheet'],
            title: json['title'],
            description: json['description'],
            image: json['img'].cast<int>(),
            idOrder: json['elem_order']);
      case 'FlashcardCustom':
        var fc = FlashcardCustom(
            id: json['id'],
            idSheet: json['id_sheet'],
            front: List<String>.from(json['front']),
            back: List<String>.from(json['back']),
            idOrder: json['elem_order']);
        return fc;
      default:
        throw Exception('Json with wrong element type');
    }
  }

  Map<String, dynamic> toJson();

  Widget toWidget();
}
