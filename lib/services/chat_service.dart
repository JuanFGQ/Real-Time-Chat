import 'package:flutter/material.dart';
import 'package:frontchat/global/environments.dart';
import 'package:frontchat/models/mensajes_response.dart';
import 'package:frontchat/models/usuario.dart';
import 'package:frontchat/services/auth_services.dart';
import 'package:http/http.dart' as http;

//*112
class ChatService with ChangeNotifier {
  Usuario? usuarioPara;

  //*119

  Future<List<Mensaje>> getChat(String usuarioID) async {
    final uri = Uri.parse(
      '${Environment.apiUrl}/mensajes/$usuarioID',
    );

    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken()
    });

    final mensajesResp = mensajesResponseFromJson(resp.body);

    return mensajesResp.mensaje;
  }
}
