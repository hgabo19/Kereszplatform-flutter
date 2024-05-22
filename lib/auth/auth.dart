import 'package:beadando/auth/login_or_register.dart';
import 'package:beadando/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  final Function(Locale) onLocaleChange;
  const AuthPage({super.key, required this.onLocaleChange});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // logged in
          if (snapshot.hasData) {
            return HomePage();
          }

          //not logged in
          else {
            return LoginOrRegister(onLocaleChange: onLocaleChange);
          }
        },
      ),
    );
  }
}
