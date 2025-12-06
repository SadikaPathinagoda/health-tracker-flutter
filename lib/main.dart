import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/splash.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HealthMate',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
