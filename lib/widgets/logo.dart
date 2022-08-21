import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  final String texto;
  final Image imagen;
  final TextStyle estilo;

  const LogoWidget(
      {Key? key,
      required this.texto,
      required this.imagen,
      required this.estilo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(margin: EdgeInsets.only(top: 50), width: 300, child: imagen),
        Text(texto, style: estilo),
      ],
    );
  }
}
