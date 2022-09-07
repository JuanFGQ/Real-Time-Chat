import 'package:flutter/material.dart';
import 'package:frontchat/helpers/mostrar_Alerta.dart';
import 'package:frontchat/services/auth_services.dart';
import 'package:frontchat/widgets/cuadro_texto.dart';
import 'package:frontchat/widgets/elevated_button.dart';
import 'package:frontchat/widgets/label.dart';
import 'package:frontchat/widgets/logo.dart';
import 'package:provider/provider.dart';

import '../services/socket_service.dart';

class RegisterPage extends StatelessWidget {
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
                    texto: 'Register',
                    imagen: Image(image: AssetImage('assets/logo.png')),
                    estilo: TextStyle(fontSize: 55)),
                _Form(),
                LabelsWidget(
                  texto1: '¿Ya tienes una cuenta?',
                  texto2: 'Inicia sesion!',
                  ruta: 'login',
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
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: [
          CuadroTextoWidget(
            textcontroller: nameCtrl,
            keyBoardType: TextInputType.text,
            icono: Icon(Icons.perm_identity),
            placeHolder: 'User Name',
            isPassword: false,
          ),
          SizedBox(height: 20),
          CuadroTextoWidget(
            textcontroller: emailCtrl,
            keyBoardType: TextInputType.emailAddress,
            icono: Icon(Icons.perm_identity),
            placeHolder: 'Email',
            isPassword: false,
          ),
          SizedBox(height: 20),
          CuadroTextoWidget(
            textcontroller: passCtrl,
            icono: Icon(Icons.password_outlined),
            placeHolder: 'password',
            isPassword: true,
          ),
          SizedBox(height: 20),
          ElevatedButtonWidget(
              texto: 'Register',

              //*97
              onPressed: authService.autenticando
                  ? null
                  : () async {
                      final registroOk = await authService.register(
                          nameCtrl.text.trim(),
                          emailCtrl.text.trim(),
                          passCtrl.text.trim());

                      if (registroOk == true) {
                        socketService.conect(); //*106
                        Navigator.pushReplacementNamed(context, 'usuarios');
                      } else {
                        mostrarAlerta(context, 'Registro Incorrecto',
                            'revise credenciales');
                      }

                      print(emailCtrl.text);
                      print(passCtrl.text);
                    })
        ],
      ),
    );
  }
}
