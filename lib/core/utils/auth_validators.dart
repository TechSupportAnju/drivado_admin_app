import 'package:email_validator/email_validator.dart';

/// Same login validation rules as `drivado_application`, in one place.
abstract final class AuthValidators {
  static bool isEmailFormatValid(String email) =>
      EmailValidator.validate(email.trim());

  static bool isEmailReady(String email) {
    final value = email.trim();
    return value.isNotEmpty && isEmailFormatValid(value);
  }

  static bool isPasswordReady(String password) => password.isNotEmpty;

  /// Empty → "Please enter your email id"
  /// Invalid format → "Please enter valid email id"
  /// Valid / not yet shown → null
  static String? emailMessage({
    required String email,
    required bool showEmptyError,
  }) {
    if (email.isEmpty) {
      return showEmptyError ? 'Please enter your email id' : null;
    }
    if (!isEmailFormatValid(email)) {
      return 'Please enter valid email id';
    }
    return null;
  }

  /// Empty after attempt → "Please enter your password"
  static String? passwordMessage({
    required String password,
    required bool showEmptyError,
  }) {
    if (password.isEmpty && showEmptyError) {
      return 'Please enter your password';
    }
    return null;
  }
}
