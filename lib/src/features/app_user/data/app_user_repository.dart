// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_folio/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_folio/src/services/firestore_service/firestore_path.dart';
import 'package:flutter_folio/src/services/firestore_service/firestore_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../domain/app_user.dart';

part 'app_user_repository.g.dart';

//this class is not in use so no need to test
class AppUserRepository {
  AppUserRepository({
    required this.service,
  });
  final FirestoreService service;

  Future<void> setAppUser(AppUser appUser) => service.setData(
      path: FirestorePath.user(appUser.uid), data: appUser.toMap());

  Stream<AppUser?> watchUser(UserID userId) => service.documentStream(
      path: FirestorePath.user(userId), builder: AppUser.fromMap);
}

@Riverpod(keepAlive: true)
AppUserRepository appUserRepository(AppUserRepositoryRef ref) {
  return AppUserRepository(service: ref.watch(firestoreServiceProvider));
}

@riverpod
Stream<AppUser?> appUserStream(AppUserStreamRef ref) {
  final user = ref.watch(authStateChangesProvider).value;
  return ref.watch(appUserRepositoryProvider).watchUser(user?.uid ?? "noId");
}
