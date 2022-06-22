import 'dart:convert';

import '/Model/Elements/element.dart';
import '/Network/client.dart';
import '/View/Interfaces/interaction_main.dart';

class Controller implements InteractionMain {
  /// VIEW INTERACTION ///


  @override
  Future<List<Element>> getElements(int idSheet) async {
    var elements = <Element>[];
    try {
      var result =
          await Client.requestResult('elements', {'id_sheet': idSheet});
      elements =
          List<Element>.from(result.map((model) => Element.fromJson(model)));
    } catch (e) {
      throw Exception(e);
    }
    return elements;
  }

  @override
  Future<void> deleteItem(String request, int id) async {
    try {
      await Client.request(request, {'id': id});
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updateItem(String request, Map<String, dynamic> json) async {
    try {
      await Client.request(request, json);
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> updateElemOrder(List<Element> list) async {
    var jsonList = <String>[];
    for (var i = 0; i < list.length; i++) {
      jsonList.add(jsonEncode(list[i]));
    }
    await Client.request('updateElementOrder', {'elem_order': jsonList});
  }
}
