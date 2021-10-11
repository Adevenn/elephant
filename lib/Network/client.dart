import 'dart:io';

import '../Exception/database_timeout_exception.dart';
import '../Exception/database_exception.dart';
import '../Exception/server_exception.dart';

import 'socket_custom.dart';

class Client{

  late final SocketCustom _socket;

  Client(String ipServer, int portServer, String database, String username, String password){
    _socket = SocketCustom(ipServer, portServer, database, username, password);
  }

  ///Try to connect to server and database
  ///
  ///If connection fails => Exception
  Future<void> testConnection() async{
    try{
      await _socket.connect();
      await _socket.writeAsym('testConnection');
      await _socket.synchronizeRead();
      await _socket.disconnectWithResult();
    }
    on ServerException { throw ServerException('Connection failed : Wrong IP or PORT or server disconnected'); }
    on DatabaseException { throw const DatabaseException('Connection failed : Wrong DATABASE, USERNAME or PASSWORD'); }
    on DatabaseTimeoutException { throw DatabaseTimeoutException('Database offline'); }
    catch(e) { throw Exception('(Client)testConnection:\n$e'); }
  }

  Future<String> cells(String matchWord) async{
    try{
      await _socket.connect();
      await _socket.writeAsym('cells');
      await _socket.synchronizeRead();
      await _socket.writeAsym(matchWord);
      //json is too long to be asymmetrically encrypted
      var cellsAsJson = await _socket.readSym();
      await _socket.disconnect();
      return cellsAsJson;
    }
    on SocketException{ throw ServerException('Connection failed'); }
    catch(e) { throw Exception('(Client)cells:\n$e'); }
  }

  Future<String> sheetsFromIdCell(int idCell) async{
    try{
      await _socket.connect();
      await _socket.writeAsym('cellContent');
      await _socket.synchronizeRead();
      await _socket.writeAsym(idCell.toString());
      var sheetsAsJson = await _socket.readSym();
      await _socket.disconnect();
      return sheetsAsJson;
    }
    on SocketException{ throw ServerException('Connection failed'); }
    catch(e) { throw Exception('(Client)sheetsFromIdCell:\n$e'); }
  }

  Future<String> elementsFromIdSheet(int idSheet) async{
    try{
      await _socket.connect();
      await _socket.writeAsym('sheetContent');
      await _socket.synchronizeRead();
      await _socket.writeAsym(idSheet.toString());
      var elementsAsJson = await _socket.readSym();
      await _socket.disconnect();
      return elementsAsJson;
    }
    on SocketException{ throw ServerException('Connection failed'); }
    catch(e) { throw Exception(e); }
  }

  Future<void> addCell(String jsonCell) async{
    try{
      await _socket.connect();
      await _socket.writeAsym('addCell');
      await _socket.synchronizeRead();
      await _socket.writeSym(jsonCell);
      await _socket.disconnectWithResult();
    }
    on ServerException { throw ServerException('Connection failed : Server disconnected'); }
    on DatabaseTimeoutException { throw DatabaseTimeoutException('Database offline'); }
    catch(e) { throw Exception(e); }
  }

  Future<void> addObject(String type, String json) async{
    try{
      await _socket.connect();
      await _socket.writeAsym('addObject');
      await _socket.synchronizeRead();
      await _socket.writeAsym(type);
      await _socket.synchronizeRead();
      await _socket.writeSym(json);
      await _socket.disconnectWithResult();
    }
    on ServerException { throw ServerException('Connection failed : Server disconnected'); }
    on DatabaseTimeoutException { throw DatabaseTimeoutException('Database offline'); }
    catch(e) { throw Exception(e); }
  }

  Future<void> deleteObject(String type, int id) async{
    try{
      await _socket.connect();
      await _socket.writeAsym('deleteObject');
      await _socket.synchronizeRead();
      await _socket.writeAsym(type);
      await _socket.synchronizeRead();
      await _socket.writeAsym(id.toString());
      await _socket.disconnectWithResult();
    }
    on ServerException { throw ServerException('Connection failed : Server disconnected'); }
    on DatabaseTimeoutException { throw DatabaseTimeoutException('Database offline'); }
    catch(e) { throw Exception(e); }
  }

  Future<void> updateObject(String type, String json) async{
    try{
      await _socket.connect();
      await _socket.writeAsym('updateObject');
      await _socket.synchronizeRead();
      await _socket.writeAsym(type);
      await _socket.synchronizeRead();
      await _socket.writeSym(json);
      await _socket.disconnectWithResult();
    }
    on ServerException { throw ServerException('Connection failed : Server disconnected'); }
    on DatabaseTimeoutException { throw DatabaseTimeoutException('Database offline'); }
    catch(e) { throw Exception(e); }
  }
}