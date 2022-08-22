import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontchat/widgets/mensaje_chat.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  List<MensajeChatWidget> _mensaje = []; //*66

  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  bool _estEscribiendo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            children: [
              CircleAvatar(
                child: Text('test'),
                maxRadius: 20,
              ),
              SizedBox(height: 3),
              Text(
                'Juan G',
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
                        data: IconThemeData(color: Colors.blue),
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
    //*si no hay texto no devuelva nada
    if (texto.length == 0) return; //*67

    print(texto);

    _focusNode.requestFocus();
    _textController.clear();

    //*65 añadir mensaje cuando se presiona la flecha
    final nuevoMensaje = MensajeChatWidget(
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 400)), //*67
        texto: texto,
        uuid: '1233');
    _mensaje.insert(0, nuevoMensaje);
    nuevoMensaje.animationController.forward(); //*68

    //*65
    setState(() {
      _estEscribiendo = false;
    });
  }

  @override
  void dispose() {
//todo: cancelar escucha del socket en chat en particular

// limpiar cada una de las instancias de los mensajes porque todos los controladores
// creados pueden consumir mas memoria de la necesaria
// *68
    for (MensajeChatWidget mensaje in _mensaje) {
      mensaje.animationController.dispose();
    }

    super.dispose();
  }
}
