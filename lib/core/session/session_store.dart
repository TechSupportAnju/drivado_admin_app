import 'package:shared_preferences/shared_preferences.dart';

class SessionStore {
  SessionStore._();
  static final SessionStore instance = SessionStore._();

  static const _onboardedKey = 'onboarded';
  static const _loggedInKey = 'logged_in';
  static const _emailKey = 'email';

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get isOnboarded => _prefs.getBool(_onboardedKey) ?? false;
  bool get isLoggedIn => _prefs.getBool(_loggedInKey) ?? false;
  String? get savedEmail => _prefs.getString(_emailKey);

  Future<void> completeOnboarding() => _prefs.setBool(_onboardedKey, true);

  Future<void> login(String email) async {
    await _prefs.setBool(_loggedInKey, true);
    await _prefs.setString(_emailKey, email);
  }

  Future<void> logout() async {
    await _prefs.setBool(_loggedInKey, false);
  }
}
