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
        return Checkbox(id: json['id'], idParent: json['idParent'], isChecked: json['isChecked'], text: json['text'], idOrder: json['idOrder']);
      case 'Image':
        return Image(id: json['id'], idParent: json['idParent'], data: Uint8List.fromList(json['data'].cast<int>()), idOrder: json['idOrder']);
      case 'Text':
        return Text(id: json['id'], idParent: json['idParent'], text: json['text'], txtType: TextType.values[json['txtType']], idOrder: json['idOrder']);
      default:
        throw Exception('Json with wrong element type');
    }
  }

  Map<String, dynamic> toJson();

}