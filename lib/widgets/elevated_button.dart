import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String texto;
  final void Function()? onPressed;

  const ElevatedButtonWidget(
      {Key? key, required this.texto, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
        child: Text(texto),
        onPressed: onPressed,
      ),
    );
  }
}
