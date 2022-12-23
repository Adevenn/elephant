import 'dart:convert';

import 'package:elephant_client/Model/Elements/image_custom.dart';
import 'package:elephant_client/Network/client.dart';

import '/Model/Elements/element_custom.dart';

/// int id,
///
/// int idParent,
///
/// String title,
///
/// String subtitle,
///
/// List elements,
///
/// int idOrder
class PageCustom {
  final int id;
  final int idParent;
  String title;
  String subtitle;
  List<ElementCustom> elements = [];
  int idOrder;

  PageCustom(this.id, this.idParent, this.title, this.subtitle, this.idOrder);

  PageCustom.fromJson(Map<String, dynamic> json)
      : id = json['id_sheet'],
        idParent = json['id_cell'],
        title = json['title'],
        subtitle = json['subtitle'],
        idOrder = json['sheet_order'];

  Map<String, dynamic> toJson() => {
        'id_sheet': id,
        'id_cell': idParent,
        'title': title,
        'subtitle': subtitle,
        'sheet_order': idOrder,
      };

  ///Get elements that match with [id]
  Future<void> getElements() async {
    try {
      var result = await Client.requestResult('elements', {'id_sheet': id});
      elements = List<ElementCustom>.from(
          result.map((model) => ElementCustom.fromJson(model)));
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Add checkbox element
  Future<void> addCheckbox() async =>
      await Client.request('addCheckbox', {'id_sheet': id});

  ///Add image element
  Future<void> addImage(List<ImageCustom> images) async {
    try {
      for (var image in images) {
        await Client.request('addImage', {
          'id_sheet': id,
          'img_preview': image.imgPreview,
          'img_raw': image.imgRaw
        });
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Add text element
  Future<void> addTexts(int txtType) async =>
      await Client.request('addText', {'id_sheet': id, 'txt_type': txtType});

  ///Add flashcard element
  Future<void> addFlashcard() async =>
      await Client.request('addFlashcard', {'id_sheet': id});

  ///Delete an element
  Future<void> deleteElement(int index) async =>
      await Client.deleteItem(elements[index].id, 'element');

  ///Reorder elements and update database
  Future<void> reorderElements(int oldIndex, int newIndex) async {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    ElementCustom item = elements.removeAt(oldIndex);
    elements.insert(newIndex, item);

    var jsonList = <String>[];
    for (var i = 0; i < elements.length; i++) {
      jsonList.add(jsonEncode(elements[i]));
    }
    await Client.request('updateElementOrder', {'elem_order': jsonList});
  }
}
