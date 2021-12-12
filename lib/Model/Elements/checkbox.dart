import 'element.dart';

class Checkbox extends Element{
  bool isChecked;
  String text;

  Checkbox({this.isChecked = false, required this.text, required int id, required int idParent, required int idOrder})
    : super(id: id, idParent: idParent, idOrder: idOrder);

  @override
  Map<String, dynamic> toJson() => {
    'id' : id,
    'id_parent' : idParent,
    'is_checked' : isChecked,
    'text' : text,
    'id_order' : idOrder,
    'type' : runtimeType.toString(),
  };
}
