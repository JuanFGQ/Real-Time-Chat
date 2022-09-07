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

              // bloquear boton cuando esta en proceso de autenticacion
              onPressed: authService.autenticando
                  ? null
                  : () async {
                      // quitar teclado cuando ya se haga la autenticacion
                      FocusScope.of(context).unfocus(); //*94

                      //*92
                      // aqui llamo al login desde el servicio auth service
                      //  le pongo como argumento emailCtrl.text, passCtrl.text
                      // porque esos dos son lo que me reciben la info desde la ventana de login
                      // cuando la reciben la mandan al back para autenticar

                      //*modificado en 95
                      final loginOk = await authService.login(
                        emailCtrl.text,
                        passCtrl.text.trim(),
                      ); //*92//*94 trim

                      if (loginOk) {
                        socketService
                            .conect(); //funcion para conectar al socket*106
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
