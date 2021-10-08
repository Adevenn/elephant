import 'checkbox.dart';
import 'images.dart';
import 'texts.dart';
import 'text_type.dart';

abstract class Element{
  final int id;
  final int idParent;
  int idOrder;

  Element({required this.id, required this.idParent, required this.idOrder});

  factory Element.fromJson(Map<String, dynamic> json){
    switch(json['type']){
      case 'CheckBox':
        return CheckBox(id: json['id'], idParent: json['idParent'], isChecked: json['isChecked'], text: json['text'], idOrder: json['idOrder']);
      case 'Images':
        return Images(id: json['id'], idParent: json['idParent'], data: json['data'], idOrder: json['idOrder']);
      case 'Texts':
        return Texts(id: json['id'], idParent: json['idParent'], text: json['text'], txtType: TextType.values[json['txtType']], idOrder: json['idOrder']);
      default:
        throw Exception('Json with wrong element type');
    }
  }

  Map<String, dynamic> toJson();

}