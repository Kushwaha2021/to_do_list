
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:to_do_list/constants.dart';

import '../main.dart';
import '../screens/auth/forgot_password_page.dart';
import '../services/auth_service.dart';
import '../services/firebase_exceptions.dart';
import '../utils/custom_snackbar.dart';
import '../utils/loder.dart';

class LoginScreen extends StatefulWidget {
  final Function() onClickedSignUp;
  const LoginScreen({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _authService = AuthService();
  bool _obscureText = true;
  FocusNode emailFocusNode = new FocusNode();
  FocusNode passFocusNode = new FocusNode();
  bool invalidEmail=false;
  bool invalidPass=false;
  @override
  void initState() {
    emailFocusNode.addListener((){ setState((){}); });
    super.initState();
  }
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Login',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
          foregroundColor:  Colors.black,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(height: MediaQuery.of(context).size.height/5),
                TextFormField(
                  focusNode: emailFocusNode,
                  controller: emailController,
                  textInputAction: TextInputAction.next,

                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: const OutlineInputBorder(),
                    labelStyle:  TextStyle(
                        color: emailFocusNode.hasFocus ? (invalidEmail?Colors.red:mainColor) : Colors.black45
                    ),
                    focusedBorder: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(color: mainColor),
                    ),
                  ),

                  autovalidateMode:
                  AutovalidateMode.onUserInteraction,
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
                TextFormField(
                  focusNode: passFocusNode,
                  controller: passwordController,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle:  TextStyle(
                        color: passFocusNode.hasFocus ? (invalidPass?Colors.red:mainColor) : Colors.black45
                    ),
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(15),
                      borderSide:BorderSide(color: mainColor),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        semanticLabel:
                        _obscureText ? 'show password' : 'hide password',
                        color: mainColor,
                      ),
                    ),
                  ),
                  obscureText: _obscureText,
                  autovalidateMode:
                  AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if(value != null && value.length < 6){
                      SchedulerBinding.instance.addPostFrameCallback((timestamp) {
                        setState(() {
                          invalidPass = true;
                        });
                      });
                      return 'Enter min. 6 characters';

                    }
                    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
                      setState(() {
                        invalidPass = false;
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
                  icon: const Icon(Icons.lock_open, size: 32),
                  label: const Text(
                    textAlign: TextAlign.center,
                    'Sign In',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  onPressed: signIn,
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: mainColor,
                      fontSize: 20,
                    ),
                  ),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(
                    builder: (context) =>
                    const ForgotPasswordPage(),
                  )),
                ),
                const SizedBox(height: 24),
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        color: Colors.black, fontSize: 20),
                    text: 'No account?  ',
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignUp,
                        text: 'Sign Up',
                        style: TextStyle(
                          decoration:
                          TextDecoration.underline,
                          color: mainColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Future signIn() async {
    if (formKey.currentState!.validate()) {
      LoaderX.show(context);
      final _status = await _authService.signIn(
        emailController.text.trim(),
        passwordController.text,
      );

      if (_status == AuthStatus.successful) {
        LoaderX.hide();


      } else {
        LoaderX.hide();
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

    navigatorKey.currentState!
        .popUntil(((route) => route.isFirst));
  }
}
