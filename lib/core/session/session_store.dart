import 'package:shared_preferences/shared_preferences.dart';

class SessionStore {
  SessionStore._();
  static final SessionStore instance = SessionStore._();

  static const _onboardedKey = 'onboarded';
  static const _loggedInKey = 'logged_in';
  static const _rememberMeKey = 'remember_me';
  static const _emailKey = 'remembered_email';
  static const _passwordKey = 'remembered_password';

  late final SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool get isOnboarded => _prefs.getBool(_onboardedKey) ?? false;
  bool get isLoggedIn => _prefs.getBool(_loggedInKey) ?? false;
  bool get rememberMe => _prefs.getBool(_rememberMeKey) ?? false;
  String? get savedEmail => _prefs.getString(_emailKey);
  String? get savedPassword => _prefs.getString(_passwordKey);

  Future<void> completeOnboarding() => _prefs.setBool(_onboardedKey, true);

  Future<void> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    await _prefs.setBool(_loggedInKey, true);
    await _prefs.setBool(_rememberMeKey, rememberMe);
    if (rememberMe) {
      await _prefs.setString(_emailKey, email);
      await _prefs.setString(_passwordKey, password);
    } else {
      await _prefs.remove(_emailKey);
      await _prefs.remove(_passwordKey);
    }
  }

  Future<void> logout() async {
    await _prefs.setBool(_loggedInKey, false);
  }
}
