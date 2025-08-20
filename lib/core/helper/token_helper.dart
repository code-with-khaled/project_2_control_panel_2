import 'package:web/web.dart';

class TokenHelper {
  static void storeToken(String token) {
    window.localStorage.setItem("token", token);
  }

  static String? getToken() {
    return window.localStorage.getItem("token");
  }
}
