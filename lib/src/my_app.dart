import 'package:flutter/material.dart';
import 'package:flutter_folio/src/features/routing/app_router/app_route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      ///  _AssertionError ('package:flutter/src/widgets/app.dart': Failed assertion: line 449 pos 14:
      ///  '(routeInformationProvider ?? routeInformationParser ?? routerDelegate ?? backButtonDispatcher) == null':
      /// If the routerConfig is provided, all the other router delegates must not be provided)
      routerConfig: goRouter,
      //needs this 3 parameters for widget testing
      // routeInformationParser: goRouter.routeInformationParser,
      // routerDelegate: goRouter.routerDelegate,
      // routeInformationProvider: goRouter.routeInformationProvider,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
    );
  }
}
