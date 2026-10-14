// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Functions {
  static Functions? instance;
  late SharedPreferences preferences;
  Functions._();
  factory Functions() {
    return instance ??= Functions._();
  }

  // Reactive mirror of isLogin - the floating chat button (and anything
  // else that needs to react to login/logout without an app restart)
  // listens to this instead of polling the plain bool below.
  static final ValueNotifier<bool> loginStateNotifier = ValueNotifier<bool>(
    false,
  );

  bool isLogin = false;
  set _loggedIn(bool value) {
    isLogin = value;
    loginStateNotifier.value = value;
  }

  Future<void> testToken() async {
    preferences = await SharedPreferences.getInstance();
    String? token = await getToken();
    if (token == null || token.trim().isEmpty) {
      _loggedIn = false;
    } else {
      _loggedIn = true;
    }
  }
 Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final normalized = token.trim();
    await prefs.setString("token", normalized);
    _loggedIn = normalized.isNotEmpty;
  }
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('token');
    await prefs.remove('name');
    await prefs.remove('phone');

    // إذا بدك تمسح التوتوريال كمان
    await prefs.remove('showonetime1');
    await prefs.remove('showonetime2');
    await prefs.remove('showonetime3');

    _loggedIn = false;
  }

  Future<void> setLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("app_language", lang);
  }

  // قراءة اللغة
  Future<String?> getLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("app_language") ?? "en"; // افتراضي
  }

  bool show_tot = false;
  Future<void> deleteToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      _loggedIn = false;
    } catch (_) {}
  }

  Future<void> delettot() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('showonetime1');
      await prefs.remove('showonetime2');
      await prefs.remove('showonetime3');
    } catch (_) {}
  }

  // Future<void> setToken(String tooken) async {
  //   preferences.setString('token', tooken);
  // }
 Future<void> setToken(String token) async {
  preferences = await SharedPreferences.getInstance();
  final normalized = token.trim();
  await preferences.setString('token', normalized);
  _loggedIn = normalized.isNotEmpty;
}


  // Future<String?> getToken() async {
  //   String? token = preferences.getString('token');
  //   return token;
  // }
  Future<String?> getToken() async {
  preferences = await SharedPreferences.getInstance();
  final token = preferences.getString('token');
  if (token == null) return null;
  final normalized = token.trim();
  return normalized.isEmpty ? null : normalized;
}


  Future<void> setDataUser(String name, String phone) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
    prefs.setString('phone', phone);
  }

  Future<Map<String, String>> getdataUser() async {
    var prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    String? phone = prefs.getString('phone');

    return {"name": name!, "phone": phone!};
  }

  void set_show_tutoreial(bool show) {
    preferences.setBool('showtutoriela', show);
  }

  Future<bool> test_tot(int numoftot) async {
    preferences = await SharedPreferences.getInstance();
    // bool? first_time_inapp = await preferences.getBool('showtutoriela');
    bool? show_tot_1 = preferences.getBool('showonetime1');
    bool? show_tot_2 = preferences.getBool('showonetime2');
    bool? show_tot_3 = preferences.getBool('showonetime3');
    if (numoftot == 1) {
      if (show_tot_1 == null) {
        preferences.setBool('showonetime1', true);
        return true;
      } else {
        return false;
      }
    } else if (numoftot == 2) {
      if (show_tot_2 == null) {
        preferences.setBool('showonetime2', true);
        return true;
      } else {
        return false;
      }
    } else {
      if (show_tot_3 == null) {
        preferences.setBool('showonetime3', true);
        return true;
      } else {
        return false;
      }
    }
  }

  Future<void> deletDataUser() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove('name');
    await prefs.remove('phone');
  }
}
