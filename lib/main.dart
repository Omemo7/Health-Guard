import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:flutter_svg/svg.dart';
import 'dart:async'; 

import 'screens/LoginScreen.dart'; 



void main() {
  
  WidgetsFlutterBinding.ensureInitialized();

  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Guard Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      
      home: const WelcomeScreen(),
      
      routes: {
        '/login': (context) => const LoginScreen(),
        
        
      },
    );
  }
}


class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() {
    
    Timer(const Duration(seconds: 3), () {
      if (mounted) { 
        
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .primary, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            
            SvgPicture.asset(
              'assets/icons/health-insurance.svg',
              width: 80.0, 
              height: 80.0, 
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onPrimary, 
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 24.0),
            Text(
              'Welcome to Health Guard',
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.bold,
                color: Theme
                    .of(context)
                    .colorScheme
                    .onPrimary,
              ),
            ),
            const SizedBox(height: 16.0),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Theme
                  .of(context)
                  .colorScheme
                  .onPrimary),
            ),
            const SizedBox(height: 24.0),
            Text(
              'Loading your health companion...',
              style: TextStyle(
                fontSize: 16.0,
                color: Theme
                    .of(context)
                    .colorScheme
                    .onPrimary
                    .withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




