import 'dart:typed_data';

import 'package:crypton/crypton.dart';

class AsymEncryption{

  final RSAKeypair _serverKeys = RSAKeypair.fromRandom();
  String get publicKey => _serverKeys.publicKey.toPEM();
  late RSAPublicKey _clientKey;
  set clientKey (String key) { _clientKey = RSAPublicKey.fromPEM(key); }

  String encrypt(String plainText) => _clientKey.encrypt(plainText);

  String decrypt(Uint8List encryptedText) => _serverKeys.privateKey.decrypt(String.fromCharCodes(encryptedText));
}