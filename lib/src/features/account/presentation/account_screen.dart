// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_folio/src/common_widget/app_loader.dart';
import 'package:flutter_folio/src/common_widget/confirmation_callback.dart';

import 'package:flutter_folio/src/constants/sizes.dart';
import 'package:flutter_folio/src/features/account/presentation/account_screen_controller.dart';
import 'package:flutter_folio/src/utils/async_value_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common_widget/alert_dialogs.dart';
import '../../routing/app_router/app_route.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});
//*log out
  Future<void> _logout(
          BuildContext context, WidgetRef ref) =>
      confirmationCallback(
          context: context,
          content: "Are you sure you want to log out?",
          cancelActionText: "Cancel",
          callback: () =>
              ref.read(accountScreenControllerProvider.notifier).logout());

  //*delete account
  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) =>
      confirmationCallback(
          context: context,
          content:
              'Deleting account cannot be undone. Are you sure you want to proceed?',
          cancelActionText: "Cancel",
          callback: () => showEditBottomSheet(
                context: context,
                fieldValue: 'Enter DELETE to confirm',
                initialValue: '',
                title: '',
              ).then((value) async {
                if (value == true) {
                  await ref
                      .read(accountScreenControllerProvider.notifier)
                      .deleteAccount();
                }
              }));
//* relogin user if delete account requires so
  void _loginUser(BuildContext context, WidgetRef ref) => confirmationCallback(
      context: context,
      content:
          'This operation is sensitive and requires recent authentication. Log in again before retrying this operation',
      callback: () => context.pushNamed(AppRoute.signin.name));

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //* a listener of the controller and is responsible for showing an alert dialog to users when the controller caught an exception
    ref.listen<AsyncValue>(accountScreenControllerProvider, (_, state) {
      if (!state.isLoading && state.hasError) {
        //* delete account is sensitive and it may require user to log in again before performing a delete operation
        //* this promts the user to login when required
        final requireResentLogin =
            state.error.toString().contains('requires-recent-login');
        if (requireResentLogin) {
          return _loginUser(context, ref);
        } else {
          return state.showAlertDialogOnError(context);
        }
      }
    });
    //* this is a provider tracking the state thrown by the controller
    final state = ref.watch(accountScreenControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: state.isLoading
            ? AppLoader.circularProgress()
            : Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  gapH64,
                  const CircleAvatar(
                    radius: 50,
                    child: Icon(Icons.person_3, size: 80),
                  ),
                  const Spacer(),
                  SettingsButton(
                    icon: const Icon(Icons.logout),
                    onPressed: () => _logout(context, ref),
                    buttonLabel: 'Logout',
                    isLoading: state.isLoading,
                  ),
                  SettingsButton(
                    icon: const Icon(Icons.delete_forever_outlined),
                    onPressed: () => _deleteAccount(context, ref),
                    buttonLabel: 'Delete account',
                    isLoading: state.isLoading,
                  ),
                  const Spacer()
                ],
              )),
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  const SettingsButton({
    Key? key,
    this.icon,
    required this.onPressed,
    required this.buttonLabel,
    this.isLoading = false,
  }) : super(key: key);
  final Widget? icon;
  final void Function() onPressed;
  final String buttonLabel;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[icon!],
        TextButton(
            onPressed: isLoading ? null : onPressed, child: Text(buttonLabel))
      ],
    );
  }
}
