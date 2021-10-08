import 'dart:typed_data';

import 'element.dart';

class Images extends Element{
  Uint8List data;

  Images({required int id, required int idParent, required this.data, required int idOrder})
    : super(id: id, idParent: idParent, idOrder: idOrder);

  @override
  Map<String, dynamic> toJson() => {
    'id' : id,
    'idParent' : idParent,
    'data' : data,
    'idOrder' : idOrder,
    'type' : runtimeType.toString(),
  };
}
