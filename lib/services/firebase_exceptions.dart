import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  successful,
  wrongPassword,
  emailAlreadyExists,
  invalidEmail,
  weakPassword,
  unknown,
  invalidLoginCredentials,
  userNotFound,
  userDisabled,
  errorTooManyRequests,
  OperationNotAllowed,
  loginFailed
}

class AuthExceptionHandler {
  static handleAuthException(FirebaseAuthException e) {
    AuthStatus status;
    switch (e.code) {
      case "ERROR_EMAIL_ALREADY_IN_USE":
      case "account-exists-with-different-credential":
      case "email-already-in-use":
        status = AuthStatus.emailAlreadyExists;
        break;

      case "weak-password":
        status = AuthStatus.weakPassword;
        break;

      case "ERROR_WRONG_PASSWORD":
      case "wrong-password":
        status = AuthStatus.wrongPassword;
        break;

      case "ERROR_USER_NOT_FOUND":
      case "user-not-found":
        status = AuthStatus.userNotFound;
        break;

      case "ERROR_USER_DISABLED":
      case "user-disabled":
        status = AuthStatus.userDisabled;
        break;

      case "ERROR_TOO_MANY_REQUESTS":
      case "too-many-requests":
        status = AuthStatus.errorTooManyRequests;
        break;

      case "ERROR_OPERATION_NOT_ALLOWED":
      case "operation-not-allowed":
        status = AuthStatus.OperationNotAllowed;
        break;

      case "ERROR_INVALID_EMAIL":
      case "invalid-email":
        status = AuthStatus.invalidEmail;
        break;

      case "INVALID_LOGIN_CREDENTIALS":
      case "unknown":
      case "invalid-credential":
        status = AuthStatus.invalidLoginCredentials;
        break;
      default:
        status = AuthStatus.loginFailed;
    //return "Login failed. Please try again.";

    }

    return status;
  }

  static String generateErrorMessage(error) {
    String errorMessage;
    switch (error) {
      case AuthStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthStatus.weakPassword:
        errorMessage = "Your password should be at least 6 characters.";
        break;
      case AuthStatus.wrongPassword:
        errorMessage = "Your email or password is wrong.";
        break;
      case AuthStatus.emailAlreadyExists:
        errorMessage =
        "The email address is already in use by another account.";
        break;
      case AuthStatus.userNotFound:
        errorMessage =
        "User is not found.";
        break;
      case AuthStatus.OperationNotAllowed:
        errorMessage =
        "This operation is not allowed.";
        break;
      case AuthStatus.errorTooManyRequests:
        errorMessage =
        "Error too many requests.Please try again later";
        break;
      case AuthStatus.invalidLoginCredentials:
        errorMessage =
        "Invalid login credentials";
        break;
      case AuthStatus.userDisabled:
        errorMessage =
        "User is disabled";
        break;
      case AuthStatus.loginFailed:
        errorMessage =
        "Login failed. Please try again.";
        break;
      default:
        errorMessage = "An error occured. Please try again later.";
    }
    return errorMessage;
  }
}