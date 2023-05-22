import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app_bootstrap.dart';
import 'app_bootstrap_firebase.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final appBootstrap = AppBootstrap();
  final container = await createFirebaseProviderContainer();
  final root = appBootstrap.createRootWidget(container: container);
  runApp(root);
}
