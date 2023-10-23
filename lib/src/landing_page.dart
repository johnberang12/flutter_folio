// import 'package:flutter/material.dart';
// import 'package:flutter_folio/src/features/authentication/data/auth_repository.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';

// import 'common_widget/async_value_widget.dart';
// import 'features/introduction/welcome_screen.dart';
// import 'features/routing/bottom_natigation/home_screen.dart';

// class LandingPage extends ConsumerWidget {
//   const LandingPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final authStateChangesValue = ref.watch(authStateChangesProvider);
//     return AsyncValueWidget(
//         value: authStateChangesValue,
//         data: (user) =>
//             user == null ? const WelcomeScreen() : const HomeScreen());
//   }
// }
