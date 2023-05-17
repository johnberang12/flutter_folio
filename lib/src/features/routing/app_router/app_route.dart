import 'package:flutter/material.dart';
import 'package:flutter_folio/src/features/account/presentation/account_screen.dart';
import 'package:flutter_folio/src/features/app_settings/settings_screen.dart';
import 'package:flutter_folio/src/features/authentication/presentation/signin_screen.dart';
import 'package:flutter_folio/src/features/product/product/product_screen.dart';

import 'package:flutter_folio/src/features/routing/app_router/shell_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../product/product_list/product_list_screen.dart';
import 'custom_transition_page.dart';

part 'app_route.g.dart';

enum AppRoute {
  home(path: '/'),
  signin(path: 'signin'),
  product(path: 'product'),
  account(path: 'account'),
  settings(path: 'settings');

  const AppRoute({required this.path});
  final String path;
}

@Riverpod(keepAlive: true)
GoRouter goRouter(GoRouterRef ref) {
  final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');
  return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: AppRoute.home.path,
      routes: [
        ShellRoute(
            navigatorKey: shellNavigatorKey,
            builder: (context, state, child) => ShellWidget(child: child),
            routes: [
              GoRoute(
                  path: AppRoute.home.path,
                  name: AppRoute.home.name,
                  pageBuilder: (context, state) =>
                      buildPageWithDefaultTransition<void>(
                          context: context,
                          state: state,
                          child: const ProductListScreen()),
                  routes: [
                    GoRoute(
                        path: AppRoute.signin.path,
                        name: AppRoute.signin.name,
                        pageBuilder: (context, state) =>
                            buildPageWithDefaultTransition<void>(
                                context: context,
                                state: state,
                                child: const SigninScreen())),
                    GoRoute(
                        path: AppRoute.product.path,
                        name: AppRoute.product.name,
                        pageBuilder: (context, state) =>
                            buildPageWithDefaultTransition<void>(
                                context: context,
                                state: state,
                                child: const ProductScreen())),
                    GoRoute(
                        path: AppRoute.account.path,
                        name: AppRoute.account.name,
                        pageBuilder: (context, state) =>
                            buildPageWithDefaultTransition<void>(
                                context: context,
                                state: state,
                                child: const AccountScreen())),
                    GoRoute(
                        path: AppRoute.settings.path,
                        name: AppRoute.settings.name,
                        pageBuilder: (context, state) =>
                            buildPageWithDefaultTransition<void>(
                                context: context,
                                state: state,
                                child: const SettingsScreen())),
                  ]),
            ])
      ]);
}
