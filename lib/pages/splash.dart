import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/dashboard.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

    @override
    void initState() {
      super.initState();
      Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.pushReplacement(
          context, 
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) =>  DashboardScreen(),
            transitionDuration: const Duration(milliseconds: 2000),
            transitionsBuilder: (context, animation1, animation2, child) {
              return FadeTransition(
                opacity: animation1,
                child: child,
              );
            },
          ),
          );
      });

    }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1F64F9),
                Color(0xFFA810B0),
              ],
            ),
          ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                ),
                )
              ),
              SizedBox(height: 20),
              Text(
                'HealthMate',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              //SizedBox(height: 10),
              Text(
                'Personal Health Companion',
                style: TextStyle(
                  fontSize: 16,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: 200,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey[200],
                  color: Colors.blue,
                  minHeight: 3,
                  ),
              )
          
            ],
          ),
        ),
      
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              'Version 1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
