import 'package:flutter/material.dart';
import 'package:hawwel/featue/first_screen/widgets/welcome_transfer_layout.dart';

/// Pre-login welcome / transfer reception tab.
class Welcomyoufirstscreen extends StatelessWidget {
  const Welcomyoufirstscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const WelcomeTransferLayout(isAuthenticated: false);
  }
}
