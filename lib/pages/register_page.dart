import 'package:beadando/components/my_button.dart';
import 'package:beadando/components/my_textfield.dart';
import 'package:beadando/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // text editing controllers
  final TextEditingController usernameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController passwordConfirmController =
      TextEditingController();

  // register method
  void register() async {
    // passwords check

    if (passwordController.text != passwordConfirmController.text) {
      // error msg
      displayMessageToUser("A megadott jelszavak nem egyeznek", context);
    } else {
      // try user creation
      try {
        UserCredential? userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        // Navigator.pop(context);
      } on FirebaseAuthException catch (error) {
        // Navigator.pop(context);
        displayMessageToUser(error.code, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(255, 53, 51, 51),
      body: SingleChildScrollView(
        child: Center(
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

                // username
                MyTextfield(
                    hintText: AppLocalizations.of(context)!.username,
                    obscureText: false,
                    controller: usernameController),

                const SizedBox(
                  height: 15,
                ),

                // pwd
                MyTextfield(
                    hintText: AppLocalizations.of(context)!.password,
                    obscureText: true,
                    controller: passwordController),

                const SizedBox(
                  height: 15,
                ),

                // pwd again

                MyTextfield(
                    hintText: AppLocalizations.of(context)!.password_again,
                    obscureText: true,
                    controller: passwordConfirmController),

                const SizedBox(
                  height: 30,
                ),

                // signin btn
                MyButton(
                    text: AppLocalizations.of(context)!.register,
                    onTap: register),

                // register here

                const SizedBox(
                  height: 70,
                ),

                GestureDetector(
                  onTap: widget.onTap,
                  child: Text(
                    AppLocalizations.of(context)!.login_here,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
