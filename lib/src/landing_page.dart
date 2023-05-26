import 'package:flutter/material.dart';
import 'package:flutter_folio/src/common_widget/async_value_widget.dart';
import 'package:flutter_folio/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_folio/src/features/introduction/welcome_screen.dart';
import 'package:flutter_folio/src/features/routing/bottom_natigation/home_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStateChangesValue = ref.watch(authStateChangesProvider);
    return AsyncValueWidget(
        value: authStateChangesValue,
        data: (user) =>
            user == null ? const WelcomeScreen() : const HomeScreen());
  }
}
