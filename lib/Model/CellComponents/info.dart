import '../cell.dart';

class Info extends Cell{

  Info({required String title, String subtitle = ''}) : super(id: -1, title: title, subtitle: subtitle, type: (Info).toString());
}