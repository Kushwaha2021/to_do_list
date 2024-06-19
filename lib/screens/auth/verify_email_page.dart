import 'dart:async';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../utils/custom_snackbar.dart';
import '../../constants.dart';
import '../../services/auth_service.dart';
import '../../services/firebase_exceptions.dart';
import '../home_screen.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);

  @override
  State<VerifyEmailPage> createState() =>
      _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  final _authService = AuthService();
  @override
  void initState() {
    super.initState();
    isEmailVerified =
        FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();

      timer = Timer.periodic(
        const Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();

    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    setState(() {
      isEmailVerified =
          FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    final _status =await _authService.resetEmail();
    if (_status == AuthStatus.successful) {
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => canResendEmail = true);
    } else {
      final error =
      AuthExceptionHandler.generateErrorMessage(_status);
      if(mounted) {
        CustomSnackBar.showErrorSnackBar(
        context,
        message: error,
      );
      }
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ?  HomeScreen()
      : Scaffold(
          // appBar: AppBar(
          //   title: const Text('Verify Email',style: TextStyle(fontSize: 22, color: Colors.white),),
          //   centerTitle: true,
          //   backgroundColor: Colors.black,
          // ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'A verification email has been sent to your email.',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    backgroundColor: mainColor
                  ),
                  icon: const Icon(Icons.email, size: 32),
                  label: const Text(
                    'Resent Email',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  onPressed: canResendEmail
                      ? sendVerificationEmail
                      : null,
                ),
                const SizedBox(height: 8),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 24,color: mainColor),
                  ),
                  onPressed: () =>
                      FirebaseAuth.instance.signOut(),
                ),
              ],
            ),
          ),
        );
}
