import 'package:flutter/material.dart';
import 'package:frontchat/models/usuario.dart';
import 'package:frontchat/services/auth_services.dart';
import 'package:frontchat/services/chat_service.dart';
import 'package:frontchat/services/socket_service.dart';
import 'package:frontchat/services/usuarios_service.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final usuarioService = new UsuarioService(); //*111

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List<Usuario> usuarios = []; //*111

  @override
  void initState() {
    this._cargarUsuarios(); //*111
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context); //*99
    final usuario = authService.usuario; //*99
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            usuario.nombre, //*99
            style: TextStyle(color: Colors.black87),
          ),
        ),
        elevation: 2,
        backgroundColor: Colors.white70,
        leading: IconButton(
            onPressed: () {
              socketService.disconnect();
              Navigator.pushReplacementNamed(context, 'login');
              AuthService.deleteToken();
            },
            icon: Icon(
              Icons.exit_to_app_sharp,
              color: Colors.black,
            )),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: (socketService.serverStatus == ServerStatus.Online) //*107
                ? Icon(Icons.check_circle, color: Colors.green)
                : Icon(Icons.check_circle, color: Colors.red),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarUsuarios,
        header: WaterDropHeader(
          complete: Icon(Icons.check_box, color: Colors.blue),
        ),
        child: _ListViewUsuarios(),
      ),
    );
  }

  ListView _ListViewUsuarios() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuariosListTile(usuarios[i]),
      separatorBuilder: (_, i) => Divider(),
      itemCount: usuarios.length,
    );
  }

  ListTile _usuariosListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        child: Text(usuario.nombre.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      //*112
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);

        /*
       aqui habia que igualar el chatService,usuarioPara con el usuario 
       que hay establecido como lista vacia, ya que este es el que trae la informacio
       por esa razon me daba resultado nulo en el print, porque no habia puesto la
       igualdad
       */
        chatService.usuarioPara = usuario; //*112
        Navigator.pushNamed(context, 'chat'); //*112

        print(chatService.usuarioPara?.nombre);
        print(usuario.uid);
      },
    );
  }

  _cargarUsuarios() async {
    this.usuarios = await usuarioService.getUsuarios(); //*111
    setState(() {});

    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }
}
