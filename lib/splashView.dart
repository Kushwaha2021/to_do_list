
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:to_do_list/screens/routes.dart';



class SplashView extends StatefulWidget {
  const SplashView({super.key});
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    autoNavigateToNxtScreen(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      body: const SizedBox(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Text(
                  //      'Powered by', style:TextStyle(color: Colors.grey, fontSize: 14)),
                  SizedBox(
                    height: 10,
                  ),
                  Text('v.1.0.0',style:TextStyle(color: Colors.grey,fontSize: 12)),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      'www.todo.com', style:TextStyle(color: Colors.grey, fontSize: 14)),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  void autoNavigateToNxtScreen(BuildContext context) {
    Timer(const Duration(seconds: 2), () {

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const Routes()),
              (route) => false);
    });
  }
}
