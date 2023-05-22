import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_folio/src/common_widget/app_toast.dart';
import 'package:flutter_folio/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_folio/src/features/camera/data/image_picker_repository.dart';
import 'package:flutter_folio/src/features/image_upload/image_upload_repository.dart';
import 'package:flutter_folio/src/features/product/data/product_repository.dart';
import 'package:flutter_folio/src/services/auth_service.dart';
import 'package:flutter_folio/src/services/firestore_service/firestore_service.dart';
import 'package:flutter_folio/src/services/image_picker_service.dart';
import 'package:flutter_folio/src/services/permission_handler_service.dart';
import 'package:flutter_folio/src/utils/api_retry.dart';
import 'package:flutter_folio/src/utils/connection_checker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';

class MockAPIRetry extends Mock implements APIRetry {}

class MockConnectivity extends Mock implements Connectivity {}

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

class MockAppToast extends Mock implements AppToast {}

class MockFirebaseStorage extends Mock implements FirebaseStorage {}

class MockReference extends Mock implements Reference {}

class MockUploadTask extends Mock implements UploadTask {}

class MockTaskSnapshot extends Mock implements TaskSnapshot {}

class MockStorageReference extends Mock implements Reference {}

class MockFile extends Mock implements File {}

class MockImageUploadRepository extends Mock implements ImageUploadRepository {}

class MockAuthService extends Mock implements AuthService {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {
  @override
  Future<void> delete();
}

class FakeAuthCredential extends Fake implements AuthCredential {
  @override
  String get providerId => 'fake';
  @override
  String get signInMethod => 'fake';
}

class MockConnectionChecker extends Mock implements ConnectionChecker {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockImagePickerService extends Mock implements ImagePickerService {}

class MockPermissionHandlerService extends Mock
    implements PermissionHandlerService {}

class MockImagePickerRepository extends Mock implements ImagePickerRepository {}

class MockFirestoreService extends Mock implements FirestoreService {}

class MockProductRepository extends Mock implements ProductRepository {}
