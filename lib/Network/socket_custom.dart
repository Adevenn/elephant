import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import '/Exception/database_exception.dart';
import '/Exception/database_timeout_exception.dart';
import '/Exception/server_exception.dart';

import 'Encryption/asym_encryption.dart';
import 'Encryption/sym_encryption.dart';

class SocketCustom {
  late Socket _socket;
  late StreamQueue _queue;
  final AsymEncryption _asym = AsymEncryption();
  final SymEncryption _sym = SymEncryption();
  final String _ipServer;
  final int _portServer;
  late String _jsonDatabase;

  SocketCustom(this._ipServer, this._portServer, String database,
      String username, String password) {
    var databaseValues = {
      'database': database,
      'username': username,
      'password': password
    };
    _jsonDatabase = jsonEncode(databaseValues);
  }

  ///Send database, username and password
  Future<void> _dbValues() async {
    await writeSym(_jsonDatabase);
    await synchronizeRead();
  }

  Future<void> init() async {
    try {
      _socket = await Socket.connect(_ipServer, _portServer,
          timeout: const Duration(seconds: 5));
      _queue = StreamQueue(_socket);
      _socket.write('init');

      //Key Exchange
      _asym.clientKey = await read();
      await writeAsym(_sym.key);
      await synchronizeRead();

      await _dbValues();
      var result = await read();
      await disconnect();
      if (result == 'databaseTimeout') {
        throw const DatabaseTimeoutException();
      } else if (result == 'failed') {
        throw const DatabaseException();
      } else if (result != 'success') {
        throw const ServerException();
      }
    } on SocketException catch (e) {
      throw ServerException('(SocketCustom)init:\n$e');
    } on ServerException catch (e) {
      throw ServerException('(SocketCustom)init:\n$e');
    } on DatabaseException catch (e) {
      throw DatabaseException('(SocketCustom)init:\n$e');
    } on DatabaseTimeoutException catch (e) {
      throw DatabaseTimeoutException('(SocketCustom)init:\n$e');
    } catch (e) {
      throw Exception(e);
    }
  }

  ///Connect the [_socket] to the server, setup encryption keys and send database values
  Future<void> setup(String request) async {
    try {
      _socket = await Socket.connect(_ipServer, _portServer,
          timeout: const Duration(seconds: 5));
      _queue = StreamQueue(_socket);

      await write(request);
      await synchronizeRead();

      ///KEY EXCHANGE
      await writeAsym(_sym.key);
      await synchronizeRead();

      await _dbValues();
    } catch (e) {
      throw ServerException('(CustomSocket)setup:\n$e');
    }
  }

  ///Disconnect the [_socket] and return an Exception if an error occurs
  ///
  ///Analyze the result send by the server and return an exception if the result != 'success'
  Future<void> disconnectWithResult() async {
    try {
      var result = await readSym();
      await _socket.flush();
      await _socket.close();
      _socket.destroy();
      switch (result) {
        case 'success':
          break;
        case 'databaseTimeout':
          throw const DatabaseTimeoutException();
        case 'failed':
          throw const DatabaseException();
        default:
          throw Exception('Wrong answer value');
      }
    } on SocketException {
      throw const ServerException();
    } on DatabaseException {
      throw const DatabaseException();
    } on DatabaseTimeoutException {
      throw const DatabaseTimeoutException();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> disconnect() async {
    await _socket.flush();
    await _socket.close();
    _socket.destroy();
  }

  Future<void> writeBigString(String file) async {
    try {
      await writeSym(file);
      await write('--- end of file ---');
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<String> readBigString() async {
    try {
      var file = '';
      while (true) {
        file += String.fromCharCodes(await _queue.next);
        if (file.endsWith('--- end of file ---')) {
          break;
        }
      }
      return _sym.decryptString(file.substring(0, file.length - 19));
    } catch (e) {
      throw Exception(e);
    }
  }

  //WRITE

  Future<void> write(String plainText) async {
    try {
      _socket.write(plainText);
    } on SocketException catch (e) {
      throw ServerException('(CustomSocket)write\n$e');
    } catch (e) {
      throw Exception('(CustomSocket)write:\n$e');
    }
  }

  Future<void> writeAsym(String plainText) async {
    try {
      _socket.write(_asym.encrypt(plainText));
    } on SocketException catch (e) {
      throw ServerException('(CustomSocket)writeAsym\n$e');
    } catch (e) {
      throw Exception('(CustomSocket)writeAsym:\n$e');
    }
  }

  Future<void> writeSym(String plainText) async {
    try {
      _socket.write(_sym.encrypt(plainText));
    } on SocketException catch (e) {
      throw ServerException('(CustomSocket)writeSym\n$e');
    } catch (e) {
      throw Exception('(CustomSocket)writeSym:\n$e');
    }
  }

  Future<void> synchronizeWrite() async {
    try {
      _socket.write('ok');
    } on SocketException catch (e) {
      throw ServerException('(CustomSocket)synchronizeWrite\n$e');
    } catch (e) {
      throw Exception('(CustomSocket)synchronizeWrite:\n$e');
    }
  }

  //READ

  Future<String> read() async {
    try {
      return String.fromCharCodes(await _queue.next);
    } on SocketException catch (e) {
      throw ServerException('(CustomSocket)read\n$e');
    } catch (e) {
      throw Exception('(CustomSocket)read;\n$e');
    }
  }

  Future<String> readSym() async {
    try {
      return _sym.decrypt(await _queue.next);
    } on SocketException catch (e) {
      throw ServerException('(CustomSocket)readSym\n$e');
    } catch (e) {
      throw Exception('(CustomSocket)readSym;\n$e');
    }
  }

  Future<void> synchronizeRead() async {
    try {
      await _queue.next;
    } on SocketException catch (e) {
      throw ServerException('(CustomSocket)synchronizeRead\n$e');
    } catch (e) {
      throw Exception('(CustomSocket)synchronizeRead:\n$e');
    }
  }
}
