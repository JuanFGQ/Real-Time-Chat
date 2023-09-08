import 'package:flutter/material.dart';
import 'package:frontchat/helpers/mostrar_Alerta.dart';
import 'package:frontchat/services/auth_services.dart';
import 'package:frontchat/services/socket_service.dart';
import 'package:frontchat/widgets/cuadro_texto.dart';
import 'package:frontchat/widgets/elevated_button.dart';
import 'package:frontchat/widgets/label.dart';
import 'package:frontchat/widgets/logo.dart';
import 'package:provider/provider.dart';

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
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);

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
              isPassword: false),
          SizedBox(height: 20),
          CuadroTextoWidget(
            textcontroller: passCtrl,
            icono: Icon(Icons.password_outlined),
            placeHolder: 'Password',
            isPassword: true,
          ),
          SizedBox(height: 20),
          ElevatedButtonWidget(
              texto: 'ingrese',

            //blocks the button when authentication process  initiate
              onPressed: authService.autenticando
                  ? null
                  : () async {
                      
                    //quite keyboard when authentication was done
                      FocusScope.of(context).unfocus(); //*94

                      //*92
                    //here i call the login from authService
                    // put the argument emailCtrl.text, passCtrl.text
                    //because those two recive the info drom login window
                    //when is receive it sent to backend for authentication

                      //*modificado en 95
                      final loginOk = await authService.login(
                        emailCtrl.text,
                        passCtrl.text.trim(),
                      ); //*92//*94 trim

                      if (loginOk) {
                        socketService
                            .conect(); //function for connect to socket*106
                        Navigator.pushReplacementNamed(context, 'usuarios');
                      } else {
                        mostrarAlerta(
                            context, 'Login incorrecto', 'Revise credenciales');
                      }
                    })
        ],
      ),
    );
  }
}
