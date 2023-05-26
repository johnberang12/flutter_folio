import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_folio/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_folio/src/features/image_upload/image_upload_repository.dart';
import 'package:flutter_folio/src/services/firestore_service/firestore_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_bootstrap.dart';
import 'app_bootstrap_firebase.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // determine whether this is a test run
  final isTest = Platform.environment['FLUTTER_TEST'] == 'true';

  // load the correct .env file
  await dotenv.load(fileName: isTest ? '.env.test' : '.env.prod');

  final appBootstrap = AppBootstrap();
  final container = await createFirebaseProviderContainer();

  //TODO: comment this line out when deploying to production
  // await loadFirebaseServicesToEmulatorSuite(container);

  final root = appBootstrap.createRootWidget(container: container);
  runApp(root);
}

//used to load and use emulator suite
Future<void> loadFirebaseServicesToEmulatorSuite(
    ProviderContainer container) async {
  await container.read(firebaseAuthProvider).useAuthEmulator('localhost', 9099);
  container.read(firestoreProvider).useFirestoreEmulator('localhost', 8080);
  await container
      .read(firebaseStorageProvider)
      .useStorageEmulator('localhost', 9199);
}
