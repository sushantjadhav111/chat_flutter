import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("FlutterChat")),
        body: Center(
          child: Text("Lodding..."),
        ));
  }
}
