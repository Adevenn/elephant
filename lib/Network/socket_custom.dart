import 'dart:io';

import 'package:async/async.dart';
import '../Exception/database_exception.dart';
import '../Exception/database_timeout_exception.dart';
import '../Exception/server_exception.dart';

import 'Encryption/asym_encryption.dart';
import 'Encryption/sym_encryption.dart';

class SocketCustom{

  late Socket _socket;
  late StreamQueue _queue;
  late AsymEncryption _asym;
  late SymEncryption _sym;
  final String _ipServer;
  final int _portServer;
  final String _database;
  final String _username;
  final String _password;
  static const _helloWord = 'HelloHackerMan';

  SocketCustom(this._ipServer, this._portServer, this._database, this._username, this._password);

  ///Connect the [_socket] to the server, setup encryption keys and send database values
  Future<void> connect() async{
    try{
      _asym = AsymEncryption();
      _sym = SymEncryption();
      _socket = await Socket.connect(_ipServer, _portServer, timeout: const Duration(seconds: 5));
      _queue = StreamQueue(_socket);

      ///HELLO WORD
      _socket.write(_helloWord);

      ///KEY EXCHANGE
      _asym.clientKey = String.fromCharCodes(await _queue.next);
      await writeAsym(_sym.key);
      await synchronizeRead();
      //publicKey is too long to be asymmetrically encrypted
      await writeSym(_asym.publicKey);
      await synchronizeRead();

      ///DATABASE, USERNAME & PASSWORD
      await writeAsym(_database);
      await synchronizeRead();
      await writeAsym(_username);
      await synchronizeRead();
      await writeAsym(_password);
      await synchronizeRead();
      print('INIT DONE');
    } catch(e){ throw ServerException('(CustomSocket)connect:\n$e'); }
  }

  ///Disconnect the [_socket] and return an Exception if an error occurs
  ///
  ///Analyze the result send by the server and return an exception if the result != 'success'
  Future<void> disconnectWithResult() async{
    try {
      var result = await readAsym();
      await _socket.flush();
      await _socket.close();
      _socket.destroy();
      print('Result: $result');
      switch(result){
        case 'success':
          break;
        case 'databaseTimeout':
          throw DatabaseTimeoutException();
        case 'failed':
          throw const DatabaseException();
        default:
          throw Exception('Wrong answer value');
      }
    }
    on SocketException { throw ServerException(); }
    on DatabaseException { throw const DatabaseException();}
    on DatabaseTimeoutException { throw DatabaseTimeoutException(); }
    catch(e) { throw Exception(e); }
  }

  Future<void> disconnect() async{
    await _socket.flush();
    await _socket.close();
    _socket.destroy();
  }

  Future<void> writeAsym(String plainText) async{
    try{ _socket.write(_asym.encrypt(plainText)); }
    on SocketException { throw ServerException('(CustomSocket)writeAsym'); }
    catch(e){ throw Exception('(CustomSocket)writeAsym:\n$e'); }
  }

  Future<void> writeSym(String plainText) async{
    try{ _socket.write(_sym.encrypt(plainText)); }
    on SocketException { throw ServerException('(CustomSocket)writeSym'); }
    catch(e){ throw Exception('(CustomSocket)writeSym:\n$e'); }
  }

  Future<void> synchronizeRead() async{
    try{ await _queue.next; }
    on SocketException { throw ServerException('(CustomSocket)synchronizeRead'); }
    catch (e){ throw Exception('(CustomSocket)synchronizeRead:\n$e'); }
  }

  Future<void> synchronizeWrite() async{
    try{ _socket.write('ok'); }
    on SocketException { throw ServerException('(CustomSocket)synchronizeWrite'); }
    catch (e){ throw Exception('(CustomSocket)synchronizeWrite:\n$e'); }
  }

  Future<String> readAsym() async{
    try{ return _asym.decrypt(await _queue.next); }
    on SocketException { throw ServerException('(CustomSocket)readAsym'); }
    catch(e) { throw Exception('(CustomSocket)readAsym;\n$e'); }
  }

  Future<String> readSym() async{
    try{ return _sym.decrypt(await _queue.next); }
    on SocketException { throw ServerException('(CustomSocket)readSym'); }
    catch(e) { throw Exception('(CustomSocket)readSym;\n$e'); }
  }
}