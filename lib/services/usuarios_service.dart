import 'package:frontchat/models/usuario_lista_response.dart';
import 'package:http/http.dart' as http;

import 'package:frontchat/global/environments.dart';
import 'package:frontchat/models/usuario.dart';
import 'package:frontchat/services/auth_services.dart';

class UsuarioService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/usuarios');

      final resp = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        },
      );

      final usuariosListaResponse = usuariosListaResponseFromJson(resp.body);
      return usuariosListaResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
