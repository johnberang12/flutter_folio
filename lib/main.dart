import 'package:flutter/material.dart';

import 'app_bootstrap.dart';
import 'app_bootstrap_firebase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  final appBootstrap = AppBootstrap();
  final container = await createFirebaseProviderContainer();
  final root = appBootstrap.createRootWidget(container: container);
  runApp(root);
}
