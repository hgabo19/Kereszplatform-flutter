import 'package:beadando/components/my_button.dart';
import 'package:beadando/components/my_textfield.dart';
import 'package:beadando/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  void Function()? onTap;
  final Function(Locale) onLocaleChange;

  LoginPage({super.key, required this.onTap, required this.onLocaleChange});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // text editing controllers
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  // login
  void login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (error) {
      displayMessageToUser(error.code, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 53, 51, 51),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // app name
              Text(
                AppLocalizations.of(context)!.finance_management,
                style: const TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(
                height: 40,
              ),
              // email
              MyTextfield(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController),

              const SizedBox(
                height: 15,
              ),

              // pwd
              MyTextfield(
                  hintText: AppLocalizations.of(context)!.password,
                  obscureText: true,
                  controller: passwordController),

              const SizedBox(
                height: 30,
              ),

              // signin btn
              MyButton(text: AppLocalizations.of(context)!.login, onTap: login),

              // register here

              const SizedBox(
                height: 70,
              ),

              GestureDetector(
                onTap: widget.onTap,
                child: Text(
                  AppLocalizations.of(context)!.register_here,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 70,
              ),

              Text(
                AppLocalizations.of(context)!.choose_language,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 85,
                    width: 85,
                    child: IconButton(
                      onPressed: () {
                        widget.onLocaleChange(Locale('en'));
                      },
                      icon: Image.asset('assets/images/english_flag.png'),
                    ),
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  SizedBox(
                    height: 85,
                    width: 85,
                    child: IconButton(
                      onPressed: () {
                        widget.onLocaleChange(Locale('hu'));
                      },
                      icon: Image.asset('assets/images/hungarian_flag.jpg'),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
