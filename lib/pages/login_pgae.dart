import 'package:flutter/material.dart';
import 'package:frontchat/widgets/cuadro_texto.dart';
import 'package:frontchat/widgets/elevated_button.dart';
import 'package:frontchat/widgets/label.dart';
import 'package:frontchat/widgets/logo.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(236, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Center(
              child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LogoWidget(
                    texto: 'Messenger',
                    imagen: Image(image: AssetImage('assets/logo.png')),
                    estilo: TextStyle(fontSize: 55)),
                _Form(),
                LabelsWidget(
                  texto1: '¿No tienes cuenta aun?',
                  texto2: 'Crea una',
                  ruta: 'register',
                ),
                Text('Terminos y condiciones de uso')
              ],
            ),
          )),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          CuadroTextoWidget(
            textcontroller: emailCtrl,
            keyBoardType: TextInputType.emailAddress,
            icono: Icon(Icons.email_outlined),
            placeHolder: 'Email',
          ),
          SizedBox(height: 20),
          CuadroTextoWidget(
            textcontroller: passCtrl,
            keyBoardType: TextInputType.emailAddress,
            icono: Icon(Icons.password_outlined),
            placeHolder: 'Password',
          ),
          SizedBox(height: 20),
          ElevatedButtonWidget(
              texto: 'ingrese',
              onPressed: () {
                print(emailCtrl.text);
                print(passCtrl.text);
              })
        ],
      ),
    );
  }
}
