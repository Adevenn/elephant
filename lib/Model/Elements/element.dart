import 'dart:typed_data';

import 'checkbox.dart';
import 'image.dart';
import 'text.dart';
import 'text_type.dart';

abstract class Element{
  final int id;
  final int idParent;
  int idOrder;

  Element({required this.id, required this.idParent, required this.idOrder});

  factory Element.fromJson(Map<String, dynamic> json){
    switch(json['type']){
      case 'Checkbox':
        return Checkbox(id: json['id'], idParent: json['id_parent'], isChecked: json['is_checked'], text: json['text'], idOrder: json['id_order']);
      case 'Image':
        return Image(id: json['id'], idParent: json['id_parent'], imgPreview: Uint8List.fromList(json['img_preview'].cast<int>()), idOrder: json['id_order']);
      case 'Text':
        return Text(id: json['id'], idParent: json['id_parent'], text: json['text'], txtType: TextType.values[json['txt_type']], idOrder: json['id_order']);
      default:
        throw Exception('Json with wrong element type');
    }
  }

  Map<String, dynamic> toJson();

}