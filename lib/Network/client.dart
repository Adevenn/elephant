import '/Exception/database_timeout_exception.dart';
import '/Exception/database_exception.dart';
import '/Exception/server_exception.dart';

import 'socket_custom.dart';

class Client {
  late final SocketCustom _socket;

  Client(String ipServer, int portServer, String database, String username,
      String password) {
    _socket = SocketCustom(ipServer, portServer, database, username, password);
  }

  ///Try to connect to server and database
  ///
  ///If connection fails => Exception
  Future<void> init() async {
    try {
      await _socket.init();
    } on ServerException {
      throw const ServerException(
          'Connection failed : Wrong IP or PORT or server disconnected');
    } on DatabaseException {
      throw const DatabaseException(
          'Connection failed : Wrong DATABASE, USERNAME or PASSWORD');
    } on DatabaseTimeoutException {
      throw const DatabaseTimeoutException('Database offline');
    } catch (e) {
      throw Exception('(Client)init:\n$e');
    }
  }

  Future<String> cells(String matchWord) async {
    try {
      await _socket.setup('cells');
      //Asym because matchWord can be null ('') (Sym can't send empty string)
      await _socket.writeAsym(matchWord);
      var cellsAsJson = await _socket.readBigString();
      await _socket.disconnect();
      return cellsAsJson;
    } catch (e) {
      try {
        await init();
        return await cells(matchWord);
      } catch (e) {
        throw Exception('(Client)cells:\n$e');
      }
    }
  }

  Future<String> sheets(int idCell) async {
    try {
      await _socket.setup('sheets');
      await _socket.writeSym(idCell.toString());
      var sheetsAsJson = await _socket.readBigString();
      await _socket.disconnect();
      return sheetsAsJson;
    } catch (e) {
      try {
        await init();
        return await sheets(idCell);
      } catch (e) {
        throw Exception('(Client)sheets:\n$e');
      }
    }
  }

  Future<String> sheet(int idCell, int sheetIndex) async {
    try {
      await _socket.setup('sheet');
      await _socket.writeSym(idCell.toString());
      await _socket.synchronizeRead();
      await _socket.writeSym(sheetIndex.toString());
      var jsonSheet = await _socket.readBigString();
      await _socket.disconnect();
      return jsonSheet;
    } catch (e) {
      try {
        await init();
        return await sheet(idCell, sheetIndex);
      } catch (e) {
        throw Exception('(Client)sheets:\n$e');
      }
    }
  }

  Future<String> elements(int idSheet) async {
    try {
      await _socket.setup('elements');
      await _socket.writeSym(idSheet.toString());
      var elementsAsJson = await _socket.readBigString();
      await _socket.disconnect();
      return elementsAsJson;
    } catch (e) {
      try {
        await init();
        return await elements(idSheet);
      } catch (e) {
        throw Exception('(Client)elements:\n$e');
      }
    }
  }

  Future<String> rawImage(int idImage) async {
    try {
      await _socket.setup('rawImage');
      await _socket.writeSym(idImage.toString());
      var imageData = await _socket.readBigString();
      await _socket.disconnect();
      return imageData;
    } catch (e) {
      try {
        await init();
        return await rawImage(idImage);
      } catch (e) {
        throw Exception('(Client)rawImage:\n$e');
      }
    }
  }

  Future<void> addCell(String jsonCell) async {
    try {
      await _socket.setup('addCell');
      await _socket.writeSym(jsonCell);
      await _socket.disconnectWithResult();
    } catch (e) {
      try {
        await init();
        return await addCell(jsonCell);
      } catch (e) {
        throw Exception('(Client)addCell:\n$e');
      }
    }
  }

  Future<void> addItem(String type, String json) async {
    try {
      await _socket.setup('addItem');
      await _socket.writeSym(type);
      await _socket.synchronizeRead();
      await _socket.writeBigString(json);
      await _socket.disconnectWithResult();
    } catch (e) {
      try {
        await init();
        return await addItem(type, json);
      } catch (e) {
        throw Exception('(Client)addItem:\n$e');
      }
    }
  }

  Future<void> deleteItem(String type, int id) async {
    try {
      await _socket.setup('deleteItem');
      await _socket.writeSym(type);
      await _socket.synchronizeRead();
      await _socket.writeSym(id.toString());
      await _socket.disconnectWithResult();
    } catch (e) {
      try {
        await init();
        deleteItem(type, id);
      } catch (e) {
        throw Exception('(Client)deleteItem:\n$e');
      }
    }
  }

  Future<void> updateItem(String type, String json) async {
    try {
      await _socket.setup('updateItem');
      await _socket.writeSym(type);
      await _socket.synchronizeRead();
      await _socket.writeBigString(json);
      await _socket.disconnectWithResult();
    } catch (e) {
      try {
        await init();
        return await updateItem(type, json);
      } catch (e) {
        throw Exception('(Client)updateItem:\n$e');
      }
    }
  }

  Future<void> updateOrder(String type, String json) async {
    try {
      await _socket.setup('updateOrder');
      await _socket.writeSym(type);
      await _socket.synchronizeRead();
      await _socket.writeBigString(json);
      await _socket.disconnectWithResult();
    } catch (e) {
      try {
        await init();
        return await updateOrder(type, json);
      } catch (e) {
        throw Exception('(Client)updateOrder:\n$e');
      }
    }
  }
}
