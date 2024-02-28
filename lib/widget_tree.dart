import 'package:cookfit/firestore_database.dart';
import 'package:cookfit/home_page.dart';
import 'package:cookfit/login_register_page.dart';
import 'package:cookfit/onboarding_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = snapshot.data;
        if (user == null) {
          // User not logged in, show login page
          return LoginPage();
        } else {
          // User logged in, check isOnboarded status
          return FutureBuilder<bool>(
            future: getUserOnboardStatus(user.email ?? ''),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final isOnboarded = snapshot.data ?? false;
              if (isOnboarded) {
                // User is onboarded, show home page
                return const HomePage();
              } else {
                // User is not onboarded, show onboarding page
                return const OnboardingScreen();
              }
            },
          );
        }
      },
    );
  }
}
