import 'dart:developer';

import 'package:cookfit/firestore_database.dart';
import 'package:cookfit/loginPage/square_tile.dart';
import 'package:cookfit/onboarding_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../auth.dart';
import 'my_button.dart';
import 'my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    /*
         .then((message) async {
          if (message!.contains('Success')) {
            
          }
        });
    */
    // check if both password and confirm pasword is same
    if (passwordController.text == confirmPasswordController.text) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        //pop the loading circle
        Navigator.pop(context);

        await addUser(FirebaseAuth.instance.currentUser!.uid,
                emailController.text, false)
            .then((value) => Navigator.pop(context));
      } on FirebaseAuthException catch (e) {
        //pop the loading circle

        log(e.message!);
        genericErrorMessage(e.code);
      }
    } else {
      Navigator.pop(context);

      //show error password dont match
      genericErrorMessage("Password don't match!");
    }
  }

  void genericErrorMessage(String message) {
    log(message!);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 243, 243, 243),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/cook_fit_logo.png',
                  width: 200,
                  height: 200,
                ),

                //username
                MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 15),
                //password
                MyTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 15),

                MyTextField(
                  controller: confirmPasswordController,
                  hintText: 'Confirm Password',
                  obscureText: true,
                ),
                const SizedBox(height: 15),

                //sign in button
                MyButton(
                  onTap: signUserUp,
                  text: 'Sign Up',
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        'Login now',
                        style: TextStyle(
                            color: Colors.blue[900],
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // continue with
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          'OR',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                //google + apple button

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //google buttom
                    SquareTile(
                      onTap: () => AuthService().signInWithGoogle(),
                      imagePath: 'assets/google.svg',
                      height: 70,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),

                // not a memeber ? register now
              ],
            ),
          ),
        ),
      ),
    );
  }
}
