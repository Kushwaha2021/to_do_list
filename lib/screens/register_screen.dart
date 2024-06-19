
import 'package:email_validator/email_validator.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:to_do_list/services/auth_service.dart';

import '../../constants.dart';
import '../../main.dart';
import '../../utils/custom_snackbar.dart';
import '../../utils/loder.dart';
import '../services/firebase_exceptions.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onClickedSignIn;
  const RegisterScreen({
    super.key,
    required this.onClickedSignIn,
  });

  @override
  State<RegisterScreen> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _authService = AuthService();
  bool _obscureText = true;
  bool cnf_obscureText=true;
  FocusNode nameFocusNode = new FocusNode();
  FocusNode emailFocusNode= new FocusNode();
  FocusNode passFocusNode = new FocusNode();
  FocusNode cnfPassFocusNode = new FocusNode();
  bool invalidName=false;
  bool invalidEmail=false;
  bool invalidPass=false;
  bool invalidCnfPass=false;
  @override
  void initState() {
    nameFocusNode.addListener((){ setState((){}); });
    passFocusNode.addListener((){ setState((){}); });
    super.initState();
  }
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameFocusNode.dispose();
    passFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Registration',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            foregroundColor:  Colors.black,
          ),
          body:
      SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const SizedBox(height: 40),
              TextFormField(
                focusNode: nameFocusNode,
                controller: nameController,
                textInputAction: TextInputAction.next,
                decoration:  InputDecoration(
                  labelText: 'Name',
                  labelStyle:  TextStyle(
                      color: nameFocusNode.hasFocus ? (invalidName?Colors.red:mainColor) : Colors.black45
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder:  OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: mainColor),
                  ),
                ),
                autovalidateMode:
                AutovalidateMode.onUserInteraction,
                validator: (name) {
                  if (name!.isEmpty){
                    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
                      setState(() {
                        invalidName = true;
                      });});
                    return'Enter a name';
                  }
                  else if (name.length>20) {
                    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
                      setState(() {
                        invalidName = true;
                      });});
                    return 'Max 20 character is allowed';
                  }
                  else{
                    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
                      setState(() {
                        invalidName = false;
                      });});
                    return null;
                  }
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                focusNode: emailFocusNode,
                controller: emailController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle:  TextStyle(
                      color: emailFocusNode.hasFocus ? (invalidEmail?Colors.red:mainColor) : Colors.black45
                  ),
                  border: const OutlineInputBorder(),
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
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle:  TextStyle(
                      color: passFocusNode.hasFocus ? (invalidPass?Colors.red:mainColor) : Colors.black45
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: mainColor),
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
              TextFormField(
                focusNode: cnfPassFocusNode,
                controller: confirmPasswordController,
                textInputAction: TextInputAction.done,
                decoration:  InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle:  TextStyle(
                      color: cnfPassFocusNode.hasFocus ? (invalidCnfPass?Colors.red:mainColor) : Colors.black45
                  ),
                  border: const OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    // borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide(color: mainColor),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {
                      setState(() {
                        cnf_obscureText = !cnf_obscureText;
                      });
                    },
                    child: Icon(
                      cnf_obscureText ? Icons.visibility_off : Icons.visibility,
                      semanticLabel:
                      cnf_obscureText ? 'show password' : 'hide password',
                      color: mainColor,
                    ),
                  ),
                ),
                obscureText: cnf_obscureText,
                autovalidateMode:
                AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if(passwordController.text != confirmPasswordController.text){
                    SchedulerBinding.instance.addPostFrameCallback((timestamp) {
                      setState(() {
                        invalidCnfPass = true;
                      });
                    });
                    return 'Passwords do not match';

                  }
                  SchedulerBinding.instance.addPostFrameCallback((timestamp) {
                    setState(() {
                      invalidCnfPass = false;
                    });
                  });
                  return  null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      backgroundColor: mainColor
                  ),
                  icon: const Icon(Icons.arrow_forward,
                      size: 32),
                  label: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  onPressed: signUp),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                      color: Colors.black, fontSize: 20),
                  text: 'Already have an account?  ',
                  children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      text: 'Log In',
                      style: TextStyle(
                          decoration:
                          TextDecoration.underline,
                          color: mainColor
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ));

  Future signUp() async {

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      LoaderX.show(context);
      final _status = await _authService.createAccount(
          email: emailController.text.trim(),
          password: passwordController.text,
          name: nameController.text.toTitleCase().trim(),
      );


      if (_status == AuthStatus.successful) {

        LoaderX.hide();

      } else {
        LoaderX.hide();
        final error =
        AuthExceptionHandler.generateErrorMessage(
            _status);
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
