import 'dart:async';

import 'package:first_project/add_book_page.dart';
import 'package:first_project/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options:
  const FirebaseOptions(apiKey: 'AIzaSyA6GHyTlS2hLBoDK7LfcN-SrdN0psyCI10',
                        appId: '1:547938326682:android:73744484c9aefffc5a2723',
                        messagingSenderId: '547938326682',
                        projectId: 'mobile1-b632a'));

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    print('Caught Flutter error: ${details.exception}');
  };

  //await FirebaseAuth.instance.signOut();
  runZonedGuarded(() {
    runApp(const MyApp());
  }, (error, stackTrace) {
    print('Caught zoned error: $error');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Favorite Books App',
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const AuthPage();
          }
        },
      ),
      routes: {
        '/addBook': (context) => const AddBookPage()
      },
    );
  }
}
