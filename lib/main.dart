import 'package:flutter/material.dart';
import 'package:frontchat/routes/main_routes.dart';
import 'package:frontchat/services/auth_services.dart';
import 'package:frontchat/services/chat_service.dart';
import 'package:frontchat/services/socket_service.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SocketService()),
        ChangeNotifierProvider(create: (_) => ChatService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: 'login',
        routes: appRoutes,
      ),
    );
  }
}
