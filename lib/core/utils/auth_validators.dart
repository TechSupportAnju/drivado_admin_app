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

  static String? confirmPasswordMessage({
    required String password,
    required String confirmPassword,
    required bool showEmptyError,
  }) {
    if (confirmPassword.isEmpty) {
      return showEmptyError ? 'Please enter your confirm password' : null;
    }
    if (confirmPassword != password) {
      return 'Password and Confirm Password should be same';
    }
    return null;
  }

  static String? requiredMessage({
    required String value,
    required String emptyMessage,
    required bool showEmptyError,
  }) {
    if (value.trim().isEmpty) {
      return showEmptyError ? emptyMessage : null;
    }
    return null;
  }

  static String? signupEmailMessage({
    required String email,
    required bool showEmptyError,
  }) {
    final value = email.trim();
    if (value.isEmpty) {
      return showEmptyError ? 'Please enter your email ID' : null;
    }
    if (!isEmailFormatValid(value)) {
      return 'Please enter a valid email ID';
    }
    return null;
  }

  static String? confirmEmailMessage({
    required String email,
    required String confirmEmail,
    required bool showEmptyError,
  }) {
    final confirm = confirmEmail.trim();
    if (confirm.isEmpty) {
      return showEmptyError ? 'Please enter your confirm email ID' : null;
    }
    if (confirm != email.trim()) {
      return 'Email and confirm email must be same';
    }
    return null;
  }
}
