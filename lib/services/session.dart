import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static Map<String, dynamic>? currentUser;

  static Future<bool> isMfaVerified(String email) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('mfa_verified_$email') ?? false;
  }

  static Future<void> setMfaVerified(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('mfa_verified_$email', true);
  }

  static Future<void> clearMfaVerified(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('mfa_verified_$email');
  }
}
