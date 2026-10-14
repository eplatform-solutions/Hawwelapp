import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hawwel/constans/localization/lang_cubit.dart';
import 'package:flutter/material.dart';

class LangHelper {
  static bool isArabic(BuildContext context) {
    final langCubit = BlocProvider.of<LanguageCubit>(context, listen: false);
    return langCubit.state == Language.arabic;
  }
}
