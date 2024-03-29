import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontchat/models/mensajes_response.dart';
import 'package:frontchat/services/auth_services.dart';
import 'package:frontchat/services/chat_service.dart';
import 'package:frontchat/services/socket_service.dart';
import 'package:frontchat/widgets/mensaje_chat.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final List<MensajeChatWidget> _mensaje = []; //*66

  final _textController = TextEditingController();
  /*

function to return the cursor to the text box when massage was sent
  
  */
  final _focusNode = FocusNode(); //*64

  ChatService?
      chatService; //*114  to get user info and the class instance
  late SocketService socketService; //*114 to get emit function
  AuthService? authService; //*114 to find out who sent the message

  bool _estEscribiendo = false;

  @override
  void initState() {
    super.initState();

    this.chatService = Provider.of<ChatService>(context, listen: false); //*114
    this.socketService =
        Provider.of<SocketService>(context, listen: false); //*114
    this.authService = Provider.of<AuthService>(context, listen: false); //*114

    //listen what server emits //*115
    socketService.socket.on('mensaje-personal', _escucharMensaje);

//load message history
    _cargarHistorialMensajes(this.chatService!.usuarioPara!.uid); //*119
  }

  //*119 //************************************************************** */

  void _cargarHistorialMensajes(String usuarioID) async {
    List<Mensaje> chat = await this.chatService!.getChat(usuarioID);

    print(chat);

    final history = chat.map(
      (e) => MensajeChatWidget(
          texto: e.mensaje,
          uuid: e.de,
          animationController: AnimationController(
              vsync: this, duration: Duration(milliseconds: 0))
            ..forward()),
    );

    setState(() {
      _mensaje.insertAll(0, history);
    });
  }

  //**************************************************************

//*115  //**************************************************** */

  void _escucharMensaje(dynamic payload) {
    MensajeChatWidget mensaje = MensajeChatWidget(
        texto: payload['mensaje'],
        uuid: payload['de'],
        animationController: AnimationController(
          vsync: this,
          duration: Duration(milliseconds: 300),
        ));

    setState(() {
      _mensaje.insert(0, mensaje);
    });
    mensaje.animationController.forward();
  }
  //**************************************************** */

  @override
  Widget build(BuildContext context) {
    final chatService = Provider.of<ChatService>(context);
    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              CircleAvatar(
                child: Text(usuarioPara?.nombre.substring(0, 2) ?? "?"), //*112
                maxRadius: 20,
              ),
              SizedBox(height: 3),
              Text(
                usuarioPara?.nombre ?? "?", //*112
                style: TextStyle(color: Colors.limeAccent, fontSize: 15),
              )
            ],
          ),
        ),
        centerTitle: true,
        elevation: 5,
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _mensaje.length, //*64

                itemBuilder: (_, i) => _mensaje[i], //*64


                /*

The reverse function is used to send the widgets from top to bottom                */
                reverse: true,
              ),
            ),
            Divider(height: 10),
            Container(
              color: Colors.white,
              child: _inputChat(),
            ),
          ],
        ),
      ),
    );
  }

  //*64 *InputChat

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmint,
                onChanged: (texto) {
                  setState(() {
                    if (texto.length > 0) {
                      _estEscribiendo = true;
                    } else {
                      _estEscribiendo = false;
                    }
                  });
                },
                decoration:
                    InputDecoration.collapsed(hintText: 'Enviar mensaje'),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Enviar'),
                      onPressed: _estEscribiendo
                          ? () =>
                              _handleSubmint(_textController.text.trim()) //*65
                          : null,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.red),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(Icons.send),
                          onPressed: _estEscribiendo
                              ? () => _handleSubmint(
                                  _textController.text.trim()) //*65
                              : null,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmint(String texto) {
    
    if (texto.length == 0) return; //*67

    print(texto);

    _focusNode.requestFocus();
    _textController.clear();

    //*65 add message at arrow pressing
    final nuevoMensaje = MensajeChatWidget(
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 400)), //*67
        texto: texto,
        uuid: authService!.usuario.uid);

    _mensaje.insert(0, nuevoMensaje);
    nuevoMensaje.animationController.forward(); //*68

    //*65
    setState(() {
      _estEscribiendo = false;

//*114
      socketService.emit('mensaje-personal', {
        'de': this.authService!.usuario.uid,
        'para': this.chatService!.usuarioPara!.uid,
        'mensaje': texto
      });
    });
  }

  @override
  void dispose() {


    /*
    clean every message instance because all created controllers can consume more needed memory
    */

// *68
    for (MensajeChatWidget mensaje in _mensaje) {
      mensaje.animationController.dispose();
    }

//*115
    this.socketService.socket.off('mensaje-personal');

    super.dispose();
  }
}
