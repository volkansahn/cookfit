import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:adapty_ui_flutter/adapty_ui_flutter.dart';
import 'package:cookfit/firestore_database.dart';
import 'package:cookfit/my_custom_adapty_observer.dart';
import 'package:cookfit/widget_tree.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'home_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  AdaptyPaywall? paywall;
  AdaptyUIView? view;

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      dotsDecorator: DotsDecorator(
        size: const Size.square(10.0),
        activeSize: const Size(20.0, 10.0),
        spacing: const EdgeInsets.symmetric(horizontal: 3.0),
        activeShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
      ),

      pages: [
        PageViewModel(
          title: "Welcome to the Search Page",
          body:
              "This page allows you to search for recipes based on your preferences.",
          image: Image.asset('assets/welcome_image.png'),
          decoration: const PageDecoration(
            titleTextStyle:
                TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 20),
          ),
        ),
        PageViewModel(
          title: "Add Ingredients & Select Preferences",
          body:
              "Click the 'Add' button to add ingredients for your recipe. Choose your cuisine, meal type, and diet type preferences.",
          image: Image.asset('assets/add_ingredient_image.png'),
          decoration: const PageDecoration(
            titleTextStyle:
                TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 20),
          ),
        ),
        // Add the MealPage to the onboarding process
        PageViewModel(
          title: "Explore Meal Details",
          body: "Discover more details about your selected meal.",
          image: Image.asset('assets/meal_details_image.png'),
          decoration: const PageDecoration(
            titleTextStyle:
                TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 20),
          ),
        ),
        PageViewModel(
          title: "Find the Ingredients",
          body: "Check the ingredients.",
          image: Image.asset('assets/meal_ingredients_image.png'),
          decoration: const PageDecoration(
            titleTextStyle:
                TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 20),
          ),
        ),
        PageViewModel(
          title: "Follow the Instruction",
          body: "Find the instruction.",
          image: Image.asset('assets/meal_instruction_image.png'),
          decoration: const PageDecoration(
            titleTextStyle:
                TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 20),
          ),
        ),
        /* VERSION 2.0
        PageViewModel(
          title: "Nutritions!",
          body: "Explore the nutritions for your meal.",
          image: Image.asset('assets/meal_details_image.png'),
          decoration: const PageDecoration(
            titleTextStyle:
                TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            bodyTextStyle: TextStyle(fontSize: 20),
          ),
        ),
        */
      ],
      onDone: () {
        // Navigate to the SearchPage when onboarding is completed
        updateUserOnboardStatus(FirebaseAuth.instance.currentUser!.uid, true)
            .whenComplete(() => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomePage(
                            isFromOnboard: true,
                          )),
                ));
      },
      showNextButton: false, // Set to true to show the next button
      done: GestureDetector(
          onTap: () async {
            updateUserOnboardStatus(
                    FirebaseAuth.instance.currentUser!.uid, true)
                .whenComplete(() => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage(
                                isFromOnboard: true,
                              )),
                    ));
          },
          child: const Text("Got It!")),
    );
  }
}
