import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/sizes.dart';
import '../../services/connectivity_service.dart';

class NoInternetListViewLoader extends ConsumerWidget {
  const NoInternetListViewLoader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connection = ref.watch(connectivityServiceProvider);
    final bottomHeight = Platform.isIOS
        ? kBottomNavigationBarHeight + 20
        : kBottomNavigationBarHeight;

    return connection
        ? SizedBox(height: bottomHeight)
        : const Center(
            child: SizedBox(
              height: 100,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator.adaptive(),
                    gapW8,
                    Text('No internet connection...'),
                  ],
                ),
              ),
            ),
          );
  }
}
