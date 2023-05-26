import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_folio/main.dart';
import 'package:flutter_folio/src/constants/test_items.dart';
import 'package:flutter_folio/src/features/authentication/data/auth_repository.dart';
import 'package:flutter_folio/src/features/camera/data/image_picker_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import '../test/src/mocks.dart';
import '../test/src/robot.dart';

//*To start this test:
//1. start emulator suite by running firebase emulators:start
//2. create a test user with a phone number of +635551234567
//3. open emulator to create a 2 test images files, one for device camera and one for device galley
//4. logout the user to the enulator.
//5. close the app from running.
//6. run this integration test by the command "flutter test integration_test"
//7. see all test passed.(Mission passed, happy coding)

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  late ImagePickerRepository imagePickerRepository;
  setUpAll(() async {
    //Load env
    await dotenv.load(fileName: '.env.test');
    registerFallbackValue(ImageSource.camera);
  });

  setUp(() {
    imagePickerRepository = MockImagePickerRepository();
  });

  testWidgets('''
signing in a user,
creating a product and saving to database,
vefifying that the newly added product is displayed in the products list,
tapping the product to view in the ProductScreen,
verifying that all the products details are desplayed correctly,
closing the ProductScreen,
logout the user
''', (tester) async {
    //Arrange
    final container = ProviderContainer();
    final r = Robot(tester);
    final storageImage = [kTestImageFiles.last];

    when(() => imagePickerRepository.pickImage(
            source: ImageSource.camera,
            deniedPermission: any(named: 'deniedPermission')))
        .thenAnswer((_) => Future.value(kTestImageFiles.first));
    when(() => imagePickerRepository.pickMultiImage(
            deniedPermission: any(named: 'deniedPermission')))
        .thenAnswer((_) => Future.value(storageImage));
    //configure to use firebase emulator suite
    await loadFirebaseServicesToEmulatorSuite(container);
    //pump MyApp
    await r.pumpMyApp(overrides: [
      imagePickerRepositoryProvider.overrideWithValue(imagePickerRepository)
    ]);
    final currentUser = container.read(authRepositoryProvider).currentUser;
    //logout the user if signedIn. Otherwise signin
    if (currentUser != null) {
      await r.logout();
      r.auth.expectGetStartedButton();
      await r.signinWithPhoneNumber();
      //add product test
      await r.addProductAndVerify();
    } else {
      await r.signinWithPhoneNumber();
      //add product test

      await r.addProductAndVerify();
      await r.logout();
    }
    // });
  });
}
