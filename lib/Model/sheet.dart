import 'Elements/element.dart';

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
    : id = json['id'],
      idParent = json['idParent'],
      title = json['title'],
      subtitle = json['subtitle'],
      idOrder = json['idOrder'];

  Map<String, dynamic> toJson() => {
    'id' : id,
    'idParent' : idParent,
    'title' : title,
    'subtitle' : subtitle,
    'idOrder' : idOrder,
  };

  void modifyTitle(String title) => this.title = title;

  void modifySubtitle(String subtitle) => this.subtitle = subtitle;

  void addElement(Element elem) => elements.add(elem);

  Element removeAtElement(int index) => elements.removeAt(index);

  void modifyElement(Element elem, int index) => elements[index] = elem;

  void swapElement(int originID, int destID){
    var element = elements[originID];
    elements[originID] = elements[destID];
    elements[destID] = element;
  }

  void sort(){
    if (elements.length > 1) {
      var isSort = false;
      while (!isSort) {
        isSort = true;
        for(var i = 1; i < elements.length; i++){
          if (elements[i].idOrder < elements[i - 1].idOrder) {
            swapElement(i, i - 1);
            isSort = false;
          }
        }
      }
    }
  }
}