import 'package:flutter/material.dart';
import 'package:flutter_folio/src/common_widget/photo_gallery.dart';
import 'package:flutter_folio/src/features/account/presentation/account_screen.dart';

import 'package:flutter_folio/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_folio/src/features/authentication/presentation/signin_screen.dart';
import 'package:flutter_folio/src/features/introduction/welcome_screen.dart';

import 'package:flutter_folio/src/features/product/presentation/product/product_screen.dart';

import 'package:flutter_folio/src/features/routing/app_router/shell_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../product/domain/product.dart';
import '../../product/presentation/add_product/add_product_screen.dart';
import '../bottom_natigation/home_screen.dart';
import 'custom_transition_page.dart';

part 'app_route.g.dart';

enum AppRoute {
  welcome(path: '/'),
  home(path: 'home'),
  signin(path: 'signin'),
  product(path: 'product'),
  account(path: 'account'),
  settings(path: 'settings'),
  addProduct(path: 'addProduct'),
  photoGallery(path: 'photoGallery');

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
      initialLocation: ref.read(authRepositoryProvider).currentUser != null
          ? "/home"
          : AppRoute.welcome.path,
      refreshListenable: ref.watch(authRepositoryProvider),
      redirect: (context, state) {
        //* redirect callback of go_router. It is responsible for redirecting the user to the correct page
        // when signingin and logging out.
        final currentUser = ref.read(authRepositoryProvider).currentUser;
        final loggingIn = state.location == '/signin';
        final loggingOut = currentUser == null && state.location == '/home';
        final loggedIn = currentUser != null;
        //redirect the user to the welcome screen when the user logs out
        if (loggingOut) return '/';
        //redirect the user to the home screen when the use logs in
        if (loggedIn && loggingIn) {
          return '/home';
        }

        return null;
      },
      routes: [
        ShellRoute(
            navigatorKey: shellNavigatorKey,
            builder: (context, state, child) => ShellWidget(child: child),
            routes: [
              GoRoute(
                  path: AppRoute.welcome.path,
                  name: AppRoute.welcome.name,
                  pageBuilder: (context, state) =>
                      buildPageWithDefaultTransition<void>(
                          context: context,
                          state: state,
                          child: const WelcomeScreen()),
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
                        path: AppRoute.home.path,
                        name: AppRoute.home.name,
                        pageBuilder: (context, state) =>
                            buildPageWithDefaultTransition<void>(
                                context: context,
                                state: state,
                                child: const HomeScreen())),
                    GoRoute(
                        path: AppRoute.product.path,
                        name: AppRoute.product.name,
                        pageBuilder: (context, state) {
                          final product = state.extra as Product;
                          return buildPageWithDefaultTransition<void>(
                              context: context,
                              state: state,
                              child: ProductScreen(product: product));
                        }),
                    GoRoute(
                        path: AppRoute.addProduct.path,
                        name: AppRoute.addProduct.name,
                        pageBuilder: (context, state) {
                          final product = state.extra as Product?;
                          return buildPageWithDefaultTransition<void>(
                              context: context,
                              state: state,
                              child: AddProductScreen(
                                product: product,
                              ));
                        }),
                    GoRoute(
                        path: AppRoute.account.path,
                        name: AppRoute.account.name,
                        pageBuilder: (context, state) =>
                            buildPageWithDefaultTransition<void>(
                                context: context,
                                state: state,
                                child: const AccountScreen())),
                    GoRoute(
                        path: AppRoute.photoGallery.path,
                        name: AppRoute.photoGallery.name,
                        pageBuilder: (context, state) {
                          final photoUrls = state.extra as List;
                          return buildPageWithDefaultTransition<void>(
                              context: context,
                              state: state,
                              child: PhotoGallery(photoUrls: photoUrls));
                        }),
                  ]),
            ])
      ]);
}
