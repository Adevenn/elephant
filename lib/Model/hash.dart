import 'dart:convert';

import 'package:crypto/crypto.dart';

class Hash {
  static String hashString(String pwd) {
    var bytes = utf8.encode(pwd);
    return sha256.convert(bytes).toString();
  }
}
