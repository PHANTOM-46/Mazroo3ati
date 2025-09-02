import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'SignIn.dart'; // Assuming this is your SignIn page
import 'package:intl/date_symbol_data_local.dart'; // Already imported, good!

// Make sure you have your firebase_options.dart file generated
// If not, you'll need to run `flutterfire configure`
// import 'firebase_options.dart'; // Uncomment if you are using this file

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  // If you are using firebase_options.dart, it should look like this:
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // Otherwise, if you're initializing without specific options (e.g., for web/desktop or older setups):
  await Firebase.initializeApp();

  // THIS IS THE CRUCIAL FIX FOR THE LocaleDataException
  // Initialize locale data for Arabic (or any other locale used by TableCalendar)
  await initializeDateFormatting('ar', null);

  runApp(Zar3());
}

class Zar3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      title: 'Mazro3atkom',
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  Future<void> _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3)); // Simulate loading
    // Ensure the context is still mounted before navigating
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              height: MediaQuery.of(context).size.width * 0.35,
              // child: SvgPicture.asset('assets/Logo/logo.svg'),
              // Ensure 'assets/plant.png' exists and is declared in pubspec.yaml
              child: Image.asset('assets/plant.png'),
            ),
            const SizedBox(height: 5),
            Text(
              'مزروعاتي',
              style: TextStyle(
                fontFamily: 'PlaypenSansArabic',
                fontWeight: FontWeight.w500,
                fontSize: 40,
              ),
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
      ),
    );
  }
}