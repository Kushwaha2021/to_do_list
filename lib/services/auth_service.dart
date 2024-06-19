import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import 'core/firebase_firestore.dart';
import 'firebase_exceptions.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _user;
  static late AuthStatus _status;
  UserModel? get user => _user;
  bool get isAuthenticated => _user != null;

  AuthService() {
    _auth.authStateChanges().listen(_authStateChanged);
  }

  Future<AuthStatus> signIn(String email, String password) async {
      try {
        await _auth.signInWithEmailAndPassword(email: email, password: password);

        _status = AuthStatus.successful;

        return _status;
      } on FirebaseAuthException catch (e) {
        _status = AuthExceptionHandler.handleAuthException(e);
      }
      return _status;
  }

  Future<AuthStatus> createAccount({
      required String email,
      required String password,
      required String name,
  }) async {
      try {
        UserCredential newUser = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        /// update user display name
        newUser.user!.updateDisplayName(name);
        await FirebaseFirestoreService.createUser(
          email: newUser.user!.email!,
          id: newUser.user!.uid,
          name: name,
        );

        _status = AuthStatus.successful;

      } on FirebaseAuthException catch (e) {
        _status = AuthExceptionHandler.handleAuthException(e);
      }
      return _status;
    }

  Future<AuthStatus> signOut() async {
      await _auth.signOut().then((value){
        _status = AuthStatus.successful;
      })
          .catchError(
              (e) => _status = AuthExceptionHandler.handleAuthException(e));
      return _status;
    }


  void _authStateChanged(User? firebaseUser) {
    _user = firebaseUser != null ? UserModel(id: firebaseUser.uid, email: firebaseUser.email!, name:  firebaseUser.displayName!) : null;
    notifyListeners();
  }




  //
  Future<AuthStatus> resetPassword({required String email}) async {
    await _auth
        .sendPasswordResetEmail(email: email)
        .then((value) => _status = AuthStatus.successful)
        .catchError(
            (e) => _status = AuthExceptionHandler.handleAuthException(e));

    return _status;
  }
  Future<AuthStatus> resetEmail() async {
    await _auth
        .currentUser!.sendEmailVerification()
        .then((value) => _status = AuthStatus.successful)
        .catchError(
            (e) => _status = AuthExceptionHandler.handleAuthException(e));

    return _status;
  }

}
