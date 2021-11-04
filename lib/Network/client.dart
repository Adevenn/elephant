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
  Future<void> init() async{
    try{ await _socket.init(); }
    on ServerException { throw const ServerException('Connection failed : Wrong IP or PORT or server disconnected'); }
    on DatabaseException { throw const DatabaseException('Connection failed : Wrong DATABASE, USERNAME or PASSWORD'); }
    on DatabaseTimeoutException { throw const DatabaseTimeoutException('Database offline'); }
    catch(e) { throw Exception('(Client)testConnection:\n$e'); }
  }

  Future<String> cells(String matchWord) async{
    try{
      await _socket.connect('cells');
      await _socket.writeAsym(matchWord);
      //json is too long to be asymmetrically encrypted
      var cellsAsJson = await _socket.readSym();
      await _socket.disconnect();
      return cellsAsJson;
    }
    on SocketException{ throw const ServerException('Connection failed'); }
    catch(e) { throw Exception ('(Client)cells:\n$e'); }
  }

  Future<String> sheetsFromIdCell(int idCell) async{
    try{
      await _socket.connect('sheets');
      await _socket.writeAsym(idCell.toString());
      var sheetsAsJson = await _socket.readSym();
      await _socket.disconnect();
      return sheetsAsJson;
    }
    on SocketException{ throw const ServerException('Connection failed'); }
    catch(e) { throw Exception('(Client)sheetsFromIdCell:\n$e'); }
  }

  Future<String> elementsFromIdSheet(int idSheet) async{
    try{
      await _socket.connect('elements');
      await _socket.writeAsym(idSheet.toString());
      var elementsAsJson = await _socket.readBigString();
      await _socket.disconnect();
      return elementsAsJson;
    }
    on SocketException{ throw const ServerException('Connection failed'); }
    catch(e) { throw Exception(e); }
  }

  Future<void> addCell(String jsonCell) async{
    try{
      await _socket.connect('addCell');
      await _socket.writeSym(jsonCell);
      await _socket.disconnectWithResult();
    }
    on ServerException { throw const ServerException('Connection failed : Server disconnected'); }
    on DatabaseTimeoutException { throw const DatabaseTimeoutException('Database offline'); }
    catch(e) { throw Exception(e); }
  }

  Future<void> addItem(String type, String json) async{
    try{
      await _socket.connect('addItem');
      await _socket.writeAsym(type);
      await _socket.synchronizeRead();
      await _socket.writeBigString(json);
      await _socket.disconnectWithResult();
    }
    on ServerException { throw const ServerException('Connection failed : Server disconnected'); }
    on DatabaseTimeoutException { throw const DatabaseTimeoutException('Database offline'); }
    catch(e) { throw Exception(e); }
  }

  Future<void> deleteItem(String type, int id) async{
    try{
      await _socket.connect('deleteItem');
      await _socket.writeAsym(type);
      await _socket.synchronizeRead();
      await _socket.writeAsym(id.toString());
      await _socket.disconnectWithResult();
    }
    on ServerException { throw const ServerException('Connection failed : Server disconnected'); }
    on DatabaseTimeoutException { throw const DatabaseTimeoutException('Database offline'); }
    catch(e) { throw Exception(e); }
  }

  Future<void> updateItem(String type, String json) async{
    try{
      await _socket.connect('updateItem');
      await _socket.writeAsym(type);
      await _socket.synchronizeRead();
      await _socket.writeSym(json);
      await _socket.disconnectWithResult();
    }
    on ServerException { throw const ServerException('Connection failed : Server disconnected'); }
    on DatabaseTimeoutException { throw const DatabaseTimeoutException('Database offline'); }
    catch(e) { throw Exception(e); }
  }

  Future<void> updateOrder(String type, String json) async{
    try{
      await _socket.connect('updateOrder');
      await _socket.writeAsym(type);
      await _socket.synchronizeRead();
      await _socket.writeSym(json);
      await _socket.disconnectWithResult();
    }
    on ServerException { throw const ServerException('Connection failed : Server disconnected'); }
    on DatabaseTimeoutException { throw const DatabaseTimeoutException('Database offline'); }
    catch(e) { throw Exception(e); }
  }
}