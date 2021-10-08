import 'package:flutter/material.dart';
import '../View/interaction_view.dart';
import '../Model/Elements/checkbox.dart';
import '../Model/Elements/images.dart';
import '../Model/Elements/texts.dart';

import 'Elements/checkbox_custom.dart';
import 'Elements/text_field_custom.dart';

class ToolsView{
  static List<Widget> objListToWidgetList(List<Object> items, InteractionView interView){
    List<Widget> _widgets = [];
    for(var element in items) {
      switch(element.runtimeType){
        case Texts:
          _widgets.add(TextFieldCustom(interView: interView, key: UniqueKey(), texts: element as Texts));
          break;
        case Images:
          print("IMAGE TYPE");
          break;
        case CheckBox:
          _widgets.add(CheckboxCustom(interView: interView, key: UniqueKey(), checkBox: element as CheckBox));
          break;
        default:
          throw Exception("Unknown element type");
      }
    }
    return _widgets;
  }
}