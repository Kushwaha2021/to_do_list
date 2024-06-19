import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../constants.dart';
import '../../../utils/custom_snackbar.dart';
import '../../../utils/loder.dart';
import '../../services/auth_service.dart';
import '../../services/firebase_exceptions.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final _authService = AuthService();
  FocusNode emailFocusNode= new FocusNode();
  bool invalidEmail=false;
  @override
  void initState() {
    emailFocusNode.addListener((){ setState((){}); });
    super.initState();
  }
  @override
  void dispose() {
    emailController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Reset Password', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
          foregroundColor:  Colors.black,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // const SizedBox(height: 60),
                  // Image.asset('assests/images/Android-removebg-preview.png', width: 120),
                  const SizedBox(height: 40),
                  const Text(
                    'You will receive an email to\nreset your password.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    focusNode: emailFocusNode,
                    controller: emailController,
                    cursorColor: Colors.black,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle:  TextStyle(
                          color: emailFocusNode.hasFocus ? (invalidEmail?Colors.red:mainColor) : Colors.black45
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder:  OutlineInputBorder(
                        // borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: mainColor),
                      ),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) {
                      if( email != null && !EmailValidator.validate(email.trim())){
                        SchedulerBinding.instance.addPostFrameCallback((timestamp) {
                          setState(() {
                            invalidEmail = true;
                          });
                        });
                        return 'Enter a valid email';
                      }
                      SchedulerBinding.instance.addPostFrameCallback((timestamp) {
                        setState(() {
                          invalidEmail = false;
                        });
                      });
                      return null;

                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: mainColor
                    ),
                    icon: const Icon(Icons.email_outlined),
                    label: const Text(
                      'Reset Password',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    onPressed: verifyEmail,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Future verifyEmail() async {
    if (formKey.currentState!.validate()) {
      LoaderX.show(context);
      final _status = await _authService.resetPassword(email: emailController.text.trim());
      if (_status == AuthStatus.successful) {
        LoaderX.hide();

          const snackBar = 'Reset Password Email has been Sent.';

          if (!mounted) return;
        CustomSnackBar.showErrorSnackBar(
          context,
          message: snackBar,
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        LoaderX.hide();
        final error =
        AuthExceptionHandler.generateErrorMessage(_status);
        CustomSnackBar.showErrorSnackBar(
          context,
          message: error,
        );
      }
    }
  }
}
