import 'package:flutter/material.dart';

import 'screens/welcome_page.dart';

import 'theme.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp();

  runApp(const BatterApp());
}

class BatterApp extends StatelessWidget {

  const BatterApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'Batter Hub',

      debugShowCheckedModeBanner: false,

      theme: appTheme,

      home: const WelcomePage(),
    );
  }
}