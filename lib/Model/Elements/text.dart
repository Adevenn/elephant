import 'element.dart';
import 'text_type.dart';

class Text extends Element{
  String text;
  late TextType txtType;

  Text({required this.text, required this.txtType, required int id, required int idParent, required int idOrder})
      : super(id: id, idParent: idParent, idOrder: idOrder);

  @override
  Map<String, dynamic> toJson() => {
    'id' : id,
    'id_sheet' : idParent,
    'text' : text,
    'txt_type' : txtType.index,
    'elem_order' : idOrder,
    'type' : runtimeType.toString(),
  };
}
