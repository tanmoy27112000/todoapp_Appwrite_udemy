import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static late SharedPreferences _prefs;

  Future<void> init() async {
    await SharedPreferences.getInstance().then((prefs) {
      _prefs = prefs;
    });
  }

  void setSessionId(String id) {
    _prefs.setString('session', id);
  }

  String getSessionId() {
    return _prefs.getString('session') ?? '';
  }

  void clear() {
    _prefs.clear();
  }
}
