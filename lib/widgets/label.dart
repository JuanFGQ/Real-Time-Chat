import 'package:flutter/material.dart';

class LabelsWidget extends StatelessWidget {
  // final String textoLabel;
  // final TextStyle estilo;
  // const LabelsWidget({Key? key, required this.textoLabel, required this.estilo})
  //     : super(key: key);

  final String ruta;
  final String texto1;
  final String texto2;

  const LabelsWidget(
      {Key? key,
      required this.ruta,
      required this.texto1,
      required this.texto2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Text(texto1, style: TextStyle(fontSize: 15)),
        SizedBox(height: 10),
        GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, ruta);
            },
            child: Text(texto2,
                style: TextStyle(fontSize: 25, color: Colors.blue))),
      ],
    ));
  }
}
