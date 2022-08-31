export 'sign_in_with_apple.dart';
export 'display_sizes_helper.dart';
export 'assets.dart';

class Utils {
  static String? isEmailValid(String? email) {
    if (email == null || email.isEmpty) {
      return "Please complete this field.";
    }

    final isEmailValid =
        RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

    if (!isEmailValid) {
      return "Invalid email, try again";
    }

    return null;
  }

  static String? isEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return "Please complete this field.";
    }

    return null;
  }

  static String? isValidPassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Please complete this field.";
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }
}
