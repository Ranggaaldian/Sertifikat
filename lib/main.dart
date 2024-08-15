import 'package:flutter/material.dart';
import 'package:sertifikasi_jmp_kp3/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sertifikasi_jmp_kp3/user_auth/registerpage.dart';
import 'package:sertifikasi_jmp_kp3/user_auth/login_page.dart';
import 'package:sertifikasi_jmp_kp3/user_auth/sign_up.dart';
import 'package:sertifikasi_jmp_kp3/user_auth/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sertifikasi_jmp_kp3/firebase_options.dart';



Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NutriScan',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.orange),
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        // '/setting': (context) => SettingPage(),
        // '/home': (context) => HomePage(),
      },
    );
  }
}


