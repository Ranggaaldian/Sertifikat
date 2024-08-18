import 'package:flutter/material.dart';
import 'package:sertifikasi_jmp_kp3/ui/home/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sertifikasi_jmp_kp3/ui/map/map_page.dart';
import 'package:sertifikasi_jmp_kp3/ui/auth/login_page.dart';
import 'package:sertifikasi_jmp_kp3/ui/main/main_page.dart';
import 'package:sertifikasi_jmp_kp3/ui/user_auth/sign_up.dart';
import 'package:sertifikasi_jmp_kp3/ui/user_auth/splash_screen.dart';
import 'package:sertifikasi_jmp_kp3/config/firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cake by Ranggo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.orange,
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/signUp': (context) => const SignUpPage(),
        '/main': (context) => const MainPage(),
        '/map': (context) => const MapPage(),
      },
    );
  }
}
