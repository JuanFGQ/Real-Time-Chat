import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:frontchat/global/environments.dart';
import 'package:frontchat/models/login_response.dart';
import 'package:frontchat/models/usuario.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  late Usuario usuario;

  // ****************************************************************

  //*96
  final _storage = new FlutterSecureStorage();

  //static token getters

  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token!;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  // ****************************************************************

  bool _autenticando = false; //*94

  bool get autenticando => this._autenticando; //*94
  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  // **************************************************************
  //info login validation
//*93-modified 95
  Future<bool> login(String email, String password) async {
    this.autenticando = true;

    final data = {
      'email': email,
      'password': password,
    };

    //*92

    //  must be parce de url
    final uri = Uri.parse('${Environment.apiUrl}/login');

    final resp = await http.post(uri, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
    });

    print(resp.body);
    autenticando = false; //*95

//*93
    //when i have valid authentication store loginResponse.usuario
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

     
      await this._guardarToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  // **************************************************************

// *97 
  // receiving info from register info 

  Future register(String nombre, String email, String password) async {
    this.autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password,
    };

    //  route must be parse
    // /when add new is for go ro the endpoint that receives the info 
    final uri = Uri.parse('${Environment.apiUrl}/login/new');

    final resp = await http.post(uri, body: jsonEncode(data), headers: {
      'Content-Type': 'application/json',
    });

    print(resp.body);
    autenticando = false; //*95

    // when i have valid authentication store loginResponse.usuario
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      await this._guardarToken(loginResponse.token);
      return true;
    } else {
      final respBody = jsonDecode(resp.body);

      return respBody['msg'];
    }
  }

  // **************************************************************
  // *98

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token') ?? '';

    final uri = Uri.parse('${Environment.apiUrl}/login/renew');

    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': token,
    });

    print(resp.body);

    // when i have valid authentication store loginResponse.usuario
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

    
      await this._guardarToken(loginResponse.token);
      return true;
    } else {
      this.logout();
      return false;
    }
  }

  // **************************************************************

  // guardar token en sitio persistente para iniciar sesion rapido
  //save token on memory to login fast
  //*96

  Future _guardarToken(String token) {
    return _storage.write(key: 'token', value: token);
  }

//delete token from device
  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
