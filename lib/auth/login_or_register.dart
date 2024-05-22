import 'package:beadando/pages/login_page.dart';
import 'package:beadando/pages/register_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  final Function(Locale) onLocaleChange;

  const LoginOrRegister({super.key, required this.onLocaleChange});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // Initially only the login page is shown
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
          onTap: togglePages, onLocaleChange: widget.onLocaleChange);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
