// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:hawwel/featue/auth/welcomyou/widjt/language_toggle_pill.dart';
import 'package:hawwel/featue/auth/welcomyou/widjt/notification_header_button.dart';

/// Legacy wrapper — prefer [HomeTransferHeaderBar] layout in welcome screen.
class notfactionicon extends StatelessWidget {
  const notfactionicon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        LanguageTogglePill(),
        SizedBox(width: 10),
        NotificationHeaderButton(),
      ],
    );
  }
}
