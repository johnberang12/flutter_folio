// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_exception.freezed.dart';

//* run this code everytime update is made to this class
// flutter pub run build_runner build --delete-conflicting-outputs

@freezed
class AppException with _$AppException {
  //Auth
  const factory AppException.invalidPhoneNumber() = InvalidPhoneNumber;
  const factory AppException.userNotFound() = UserNotFound;
  const factory AppException.userDisabled() = UserDisabled;
  const factory AppException.invalidVerificationCode() =
      InvalidVerificationCode;
  const factory AppException.requiresRecentLogin() = RequiresRecentLogin;
  const factory AppException.unKnownError() = UnknownError;
}

class AppExceptionData {
  AppExceptionData({
    required this.code,
    required this.message,
  });
  final String code;
  final String message;

  @override
  String toString() => 'AppExceptionData(code: $code, message: $message)';
}

//

extension AppExceptionDetails on AppException {
  AppExceptionData get details {
    return when(
      invalidPhoneNumber: () => AppExceptionData(
          code: "invalid-phone-number",
          message:
              'Invalid phone number format. Please enter a valid phone number.'),
      userNotFound: () => AppExceptionData(
          code: 'user-not-found',
          message:
              'No user found for this credential. Please check your credential and try again.'),
      userDisabled: () => AppExceptionData(
          code: 'user-disabled',
          message:
              'You were disabled to use this platform. If you think this was a mistake or a bug, please contact us at support@muraitamarket.com.'),
      invalidVerificationCode: () => AppExceptionData(
          code: "invalid-verification-code",
          message:
              'Invalid verification code. Please enter the correct verification code sent to your device.'),
      requiresRecentLogin: () => AppExceptionData(
          code: "requires-recent-login",
          message:
              'This operation is sensitive and requires recent authentication. Please log in again before retrying this request'),
      unKnownError: () => AppExceptionData(
          code: "unknown-error",
          message: 'Unknow error occured. Please try again later.'),
    );
  }
}
