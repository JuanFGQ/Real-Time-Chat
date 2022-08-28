//*92
import 'dart:io';

class Environment {
  // con los metodos estaticos puedo acceder a ellos sin necesidad de instanciar la clase

  static String apiUrl = Platform.isAndroid
      ? 'http://10.0.2.2:3000/api'
      : 'http://localhost:3000/api';

  static String socketUrl =
      Platform.isAndroid ? 'http://10.0.2.2:3000' : 'http://localhost:3000';
}
