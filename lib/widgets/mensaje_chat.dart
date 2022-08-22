import 'package:flutter/material.dart';

class MensajeChatWidget extends StatelessWidget {
  final String texto;
  final String uuid;
  final AnimationController animationController;

  const MensajeChatWidget({
    Key? key,
    required this.texto,
    required this.uuid,
    required this.animationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
          parent: animationController, curve: Curves.easeOut), //*67
      child: FadeTransition(
        opacity: animationController,
        child: Container(
          child: uuid == '123' ? _miMensaje() : _otroMensaje(),
        ),
      ),
    );
  }

  Widget _miMensaje() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(bottom: 8, left: 50, right: 10),
        padding: EdgeInsets.all(8),
        child: Text(texto, style: TextStyle(color: Colors.white)),
        decoration: BoxDecoration(
          color: Colors.deepPurple,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  Widget _otroMensaje() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(bottom: 8, left: 10, right: 50),
        padding: EdgeInsets.all(8),
        child: Text(texto, style: TextStyle(color: Colors.white)),
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
