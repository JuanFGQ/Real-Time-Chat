import 'package:flutter/material.dart';
import 'package:frontchat/models/usuario.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class UsuariosPage extends StatefulWidget {
  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final usuarios = [
    Usuario(online: true, email: ' juan@gmail.com', nombre: 'juan', uuid: '1'),
    Usuario(online: false, email: ' juan@gmail.com', nombre: 'juan', uuid: '2'),
    Usuario(online: true, email: ' juan@gmail.com', nombre: 'juan', uuid: '3')
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Juanito',
            style: TextStyle(color: Colors.black87),
          ),
        ),
        elevation: 2,
        backgroundColor: Colors.white70,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.exit_to_app_sharp,
              color: Colors.black,
            )),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle, color: Colors.green),
            // child: Icon(Icons.check_circle, color: Colors.green),
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
      itemBuilder: (_, i) => _UsuariosListTile(usuarios[i]),
      separatorBuilder: (_, i) => Divider(),
      itemCount: usuarios.length,
    );
  }

  ListTile _UsuariosListTile(Usuario usuario) {
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
    );
  }

  _cargarUsuarios() async {
    {
      // monitor network fetch
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use refreshFailed()
      _refreshController.refreshCompleted();
    }
  }
}
