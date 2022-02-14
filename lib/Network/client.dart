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

  ///Send the request and parameters
  ///
  ///And wait for json as result
  Future<String> requestWithResult(
      String request, List<Object> parameters) async {
    try {
      //Send request
      await _socket.setup(request);
      //Send parameters
      for (int i = 0; i < parameters.length; i++) {
        switch (parameters[i].runtimeType.toString()) {
          case 'String':
            await _socket.writeBigString((parameters[i] as String));
            break;
          case 'int':
            await _socket.writeSym((parameters[i] as int).toString());
            break;
          default:
            throw Exception('Client.requestWithResult, request $request :\n'
                'Parameter type not implemented\n'
                'Key : ${parameters[i].runtimeType.toString()}, Value : ${parameters[i]}');
        }
        if (i < parameters.length - 1) {
          await _socket.synchronizeRead();
        }
      }
      //Wait for result
      var json = await _socket.readBigString();
      await _socket.disconnect();
      return json;
    } catch (e) {
      try {
        await init();
        return await requestWithResult(request, parameters);
      } catch (e) {
        throw Exception('Client.requestWithResult, request $request :\n'
            'Values : $parameters\$e');
      }
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

  Future<void> requestWithoutResult(
      String request, List<Object> parameters) async {
    try {
      await _socket.setup(request);
      for (int i = 0; i < parameters.length; i++) {
        switch (parameters[i].runtimeType.toString()) {
          case 'String':
            await _socket.writeBigString((parameters[i] as String));
            break;
          case 'int':
            await _socket.writeSym((parameters[i] as int).toString());
            break;
          default:
            throw Exception('Client.requestWithResult, request $request :\n'
                'Parameter type not implemented\n'
                'Key : ${parameters[i].runtimeType.toString()}, Value : ${parameters[i]}');
        }
        if (i < parameters.length - 1) {
          await _socket.synchronizeRead();
        }
      }
      await _socket.disconnectWithResult();
    } catch (e) {
      try {
        await init();
        return await requestWithoutResult(request, parameters);
      } catch (e) {
        throw Exception('Client.requestWithoutResult, request $request:\n'
            'Values : $parameters\n'
            '$e');
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
