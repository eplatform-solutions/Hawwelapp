import 'package:flutter/material.dart';
import 'package:hawwel/featue/first_screen/widgets/welcome_transfer_layout.dart';

/// Post-login home transfer tab — same layout as [Welcomyoufirstscreen].
class Welcomyou extends StatelessWidget {
  const Welcomyou({super.key});

  @override
  Widget build(BuildContext context) {
    return const WelcomeTransferLayout(isAuthenticated: true);
  }
}
