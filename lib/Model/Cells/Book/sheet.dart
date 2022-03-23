import '../../Elements/element.dart';

class Sheet{
  final int id;
  final int idParent;
  String title;
  String subtitle;
  List<Element> elements = [];
  int get elemCount => elements.length;
  int idOrder;

  Sheet(this.id, this.idParent, this.title, this.subtitle, this.idOrder);

  Sheet.fromJson(Map<String, dynamic> json)
    : id = json['id_sheet'],
      idParent = json['id_cell'],
      title = json['title'],
      subtitle = json['subtitle'],
      idOrder = json['sheet_order'];

  Map<String, dynamic> toJson() => {
    'id_sheet' : id,
    'id_cell' : idParent,
    'title' : title,
    'subtitle' : subtitle,
    'sheet_order' : idOrder,
  };
}