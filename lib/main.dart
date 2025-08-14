import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for SystemChrome
import 'package:flutter_svg/svg.dart';
import 'dart:async'; // Required for Timer

import 'screens/LoginScreen.dart'; // Import your LoginScreen
// Import your MedicationReminderScreen if you intend to navigate there after login
// import 'screens/medication_reminder_screen.dart';

void main() {
  // Optional: Ensure Flutter bindings are initialized if you do complex stuff before runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Optional: Set preferred orientations (e.g., portrait only)
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
        // Optional: Define a global page transition
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            // Example transition
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      // Start with the WelcomeScreen
      home: const WelcomeScreen(),
      // Define routes for navigation
      routes: {
        '/login': (context) => const LoginScreen(),
        // Example: '/home': (context) => const MedicationReminderScreen(), // If you have a home screen after login
        // Add other routes as needed
      },
    );
  }
}

// New Welcome Screen Widget
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
    // Wait for a few seconds then navigate
    Timer(const Duration(seconds: 3), () {
      if (mounted) { // Check if the widget is still in the tree
        // Replace the current screen with the LoginScreen so the user can't go back to the welcome screen
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // You can customize this screen to be more visually appealing
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .primary, // Example background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Replace with your app logo or an engaging graphic
            // Ensure the SVG asset is correctly placed in 'assets/icons/' and declared in pubspec.yaml
            SvgPicture.asset(
              'assets/icons/health-insurance.svg',
              width: 80.0, // Increased size for better visibility
              height: 80.0, // Increased size for better visibility
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.onPrimary, // Use onPrimary for contrast against primary background
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

// Your existing MyHomePage and _MyHomePageState are no longer the entry point.
// You can remove them or keep them if they are used elsewhere (e.g., as a demo page).
// For this setup, we're making WelcomeScreen the initial screen.

/*
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _navigateToLoginFromHome() { // Renamed to avoid conflict
    Navigator.pushNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _navigateToLoginFromHome,
              child: const Text('Go to Login Screen (from Home Demo)'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
*/