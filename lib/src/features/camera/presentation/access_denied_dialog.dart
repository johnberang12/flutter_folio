import 'package:flutter/material.dart';
import 'package:flutter_folio/src/common_widget/confirmation_callback.dart';

import '../../../common_widget/alert_dialogs.dart';
import '../../../services/permission_handler_service.dart';

Future<void> showAccessPermissionDeniedDialog({
  required BuildContext context,
  required PermissionType permissionType,
}) =>
    confirmationCallback(
        context: context,
        title: 'Access permission denied',
        content:
            'You have denied the permission to access your ${permissionType.name}. To continue using this feature, you need to grand the permission in your device settings.',
        defaultActionText: 'Open settings',
        cancelActionText: 'Cancel',
        callback: () => showUnimplementedAlertDialog(context: context));
