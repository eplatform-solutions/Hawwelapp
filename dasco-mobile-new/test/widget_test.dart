import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hawwel/constans/localization/lang_cubit.dart';
import 'package:hawwel/featue/auth/login/widjt/textfildlogin.dart';

void main() {
  testWidgets('TextFieldCustom renders and updates controller', (
    WidgetTester tester,
  ) async {
    final controller = TextEditingController();

    await tester.pumpWidget(_buildTestApp(controller: controller));

    expect(find.byType(TextFormField), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'test@example.com');
    expect(controller.text, 'test@example.com');
  });

  testWidgets('TextFieldCustom uses RTL when language is Arabic', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      _buildTestApp(controller: TextEditingController()),
    );

    final editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.textDirection, TextDirection.rtl);
  });
}

class _TestLanguageCubit extends LanguageCubit {
  _TestLanguageCubit() : super();

  @override
  Future<void> toggleLanguage() async {}

  @override
  Future<void> setLanguage(Language lang) async {}
}

Widget _buildTestApp({required TextEditingController controller}) {
  return ScreenUtilInit(
    designSize: const Size(375, 866),
    minTextAdapt: true,
    splitScreenMode: true,
    child: MaterialApp(
      home: BlocProvider<LanguageCubit>(
        create: (_) => _TestLanguageCubit(),
        child: Scaffold(
          body: TextFieldCustom(
            controller: controller,
            hintText: 'Email',
            onChanged: (_) {},
          ),
        ),
      ),
    ),
  );
}
