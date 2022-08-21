import 'package:flutter/material.dart';
import 'package:frontchat/pages/chat_page.dart';
import 'package:frontchat/pages/loading_page.dart';
import 'package:frontchat/pages/login_pgae.dart';
import 'package:frontchat/pages/register_page.dart';
import 'package:frontchat/pages/usuarios_page.dart';

final Map<String, WidgetBuilder> appRoutes = {
  'usuarios': (_) => UsuariosPage(),
  'loading': (_) => LoadingPage(),
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'chat': (_) => ChatPage(),
};
