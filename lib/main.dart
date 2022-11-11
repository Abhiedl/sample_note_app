import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/screens/home_screen.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.yellow),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    navigateToHome();
    super.initState();
  }

  navigateToHome() async {
    await Future.delayed(const Duration(seconds: 4));
    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return const HomeScreen();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Image.asset(
        'assets/images/notebook.png',
        height: 200,
      )),
    );
  }
}
