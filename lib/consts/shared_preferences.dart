import 'package:shared_preferences/shared_preferences.dart';

class shared_preferences {

  // Verificar si un valor existe
  Future<bool> isValueExists(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(key);
  }
}
