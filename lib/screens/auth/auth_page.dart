// ignore_for_file: unused_import
import 'package:flutter/material.dart';
import 'package:to_do_list/screens/login_screen.dart';
import '../register_screen.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? LoginScreen(onClickedSignUp: toggle)
      : RegisterScreen(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
