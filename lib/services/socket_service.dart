import 'package:flutter/cupertino.dart';
import 'package:frontchat/services/auth_services.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../global/environments.dart';

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket; //*31

  //*31 emit para usar directamente la funcion
  Function get emit => this._socket.emit;

  //funcion para conectar //*106
  void conect() async {
    final token = await AuthService.getToken();

    _socket = IO.io(
        // 'https://chatapp12345457.herokuapp.com/',
        Environment.socketUrl, //*106
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .enableForceNewConnection()
            .enableAutoConnect()
            .setExtraHeaders({'x-token': token}) //*108
            .build());
    _socket.onConnect((_) {
      print('conectado');
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    _socket.onDisconnect((_) {
      print('disconnect');
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }

// funcion para desconectar //*106

  void disconnect() {
    this._socket.disconnect();
  }
}
