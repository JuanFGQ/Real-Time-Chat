import 'package:flutter/material.dart';

class CuadroTextoWidget extends StatelessWidget {
  final Icon icono;
  final String placeHolder;
  final TextEditingController textcontroller;
  final TextInputType keyBoardType;
  final bool isPassword;

  const CuadroTextoWidget(
      {Key? key,
      required this.icono,
      required this.placeHolder,
      required this.textcontroller,
      this.keyBoardType = TextInputType.text,
      this.isPassword = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
      // margin: EdgeInsets.only(bottom: 40),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30)),
      child: TextField(
        controller: textcontroller,
        obscureText: isPassword,
        autocorrect: false,
        keyboardType: keyBoardType,
        decoration: InputDecoration(
            prefixIcon: icono,
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            hintText: placeHolder),
      ),
    );
  }
}
