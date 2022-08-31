String getMessageFromFirebaseErrorCode(errorCode) {
  switch (errorCode) {
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      return "Email already used. Go to login page.";
    case "weak-password":
      return "Password must be at least 8 characters";
    case "wrong-password":
      return "Wrong email/password combination.";
    case "user-not-found":
      return "No user found with this email.";
    case "user-disabled":
      return "User disabled.";
    case "operation-not-allowed":
      return "Server error, please try again later.";
    case "requires-recent-login":
      return "Server error. Log in and try again";
    case "invalid-email":
      return "Email address is invalid.";
    case "invalid-custom-token":
    case "custom-token-mismatch":
      return "Invalid token provided. Please log in or reset your password.";
    default:
      return "Login failed. Please try again.";
  }
}

String getMessageFromException(exception) {
  switch (exception) {
    default:
      return "Something happened. Please try again later.";
  }
}
