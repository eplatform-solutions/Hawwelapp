// import 'package:flutter_bloc/flutter_bloc.dart';

// enum Language { english, arabic }

// class LanguageCubit extends Cubit<Language> {
//   LanguageCubit() : super(Language.english);

//   void toggleLanguage() {
//     emit(state == Language.english ? Language.arabic : Language.english);
//   }

//   void setLanguage(Language lang) {
//     emit(lang);
//   }
// }
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

enum Language { english, arabic }

class LanguageCubit extends Cubit<Language> {
  LanguageCubit() : super(Language.arabic) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey("app_language")) {
      final deviceLang = WidgetsBinding.instance.window.locale.languageCode;

      if (deviceLang == "ar") {
        emit(Language.arabic);
      } else {
        emit(Language.english);
      }
      return;
    }

    final saved = prefs.getString("app_language");
    emit(saved == "ar" ? Language.arabic : Language.english);
  }

  Future<void> setLanguage(Language lang) async {
    emit(lang);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("app_language", lang == Language.arabic ? "ar" : "en");
  }

  Future<void> toggleLanguage() async {
    await setLanguage(state == Language.arabic ? Language.english : Language.arabic);
  }
}
