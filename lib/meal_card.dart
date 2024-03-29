import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:adapty_ui_flutter/adapty_ui_flutter.dart';
import 'package:cookfit/firestore_database.dart';
import 'package:cookfit/meal_page.dart';
import 'package:cookfit/my_custom_adapty_observer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../meal.dart';

class MealCard extends StatefulWidget {
  final Meal meal;
  final List<int> userBookmarks;
  final bool isBookmarked;
  final List<Meal> meals;

  const MealCard({
    super.key,
    required this.meal,
    required this.userBookmarks,
    required this.isBookmarked,
    required this.meals,
  });

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  late Nutrients calories;
  AdaptyPaywall? paywall;
  AdaptyUIView? view;

  @override
  void initState() {
    super.initState();
    calories = widget.meal.nutrition!.nutrients![0];
  }

  @override
  Widget build(BuildContext context) {
    bool hasCredit = false;
    return GestureDetector(
      onTap: () async {
        if (!widget.isBookmarked) {
          hasCredit = await getAndUpdateUserCredit(
            FirebaseAuth.instance.currentUser?.uid ?? '',
            FirebaseAuth.instance.currentUser?.email ?? '',
          );
        }

        if (hasCredit || widget.isBookmarked) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MealPage(
                      mealData: widget.meal,
                      meals: widget.meals,
                    )),
          );
        } else {
          String email = FirebaseAuth.instance.currentUser!.email!;
          String userID = FirebaseAuth.instance.currentUser!.uid;
          checkUserStatus(email).then((status) async {
            if (status == 'trial') {
              try {
                paywall = await Adapty().getPaywall(placementId: "trial123456");
              } on AdaptyError catch (adaptyError) {
                // handle the error
              } catch (e) {
                // handle the error
              }
            } else if (status == 'basic') {
              try {
                paywall = await Adapty().getPaywall(placementId: "789456");
              } on AdaptyError catch (adaptyError) {
                // handle the error
              } catch (e) {
                // handle the error
              }
            } else if (status == 'premium') {
              try {
                paywall =
                    await Adapty().getPaywall(placementId: "premium123456");
              } on AdaptyError catch (adaptyError) {
                // handle the error
              } catch (e) {
                // handle the error
              }
            } else {
              try {
                paywall = await Adapty().getPaywall(placementId: "456123");
              } on AdaptyError catch (adaptyError) {
                // handle the error
              } catch (e) {
                // handle the error
              }
            }
          });

          try {
            view = await AdaptyUI()
                .createPaywallView(paywall: paywall!, locale: 'en');
          } on AdaptyError catch (e) {
            // handle the error
          } catch (e) {
            // handle the error
          }
          try {
            await view!.present();
            AdaptyUI().addObserver(MyCustomAdaptyObserver());
          } on AdaptyError catch (e) {
            // handle the error
          } catch (e) {
            // handle the error
          }
        }
      },
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Add padding around the row widget
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Add an image widget to display an image
                  Image.network(
                    widget.meal.image ?? '',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  // Add some spacing between the image and the text
                  Container(width: 20),
                  // Add an expanded widget to take up the remaining horizontal space
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Add some spacing between the top of the card and the title
                        Container(height: 5),
                        // Add a title widget
                        Text(
                          widget.meal.title ?? '',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                  color: const Color(0xFF37474F),
                                  fontWeight: FontWeight.w600),
                          maxLines: 2,
                        ),
                        // Add some spacing between the title and the subtitle
                        Container(height: 10),
                        // Add a subtitle widget
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.timer,
                                    color: Colors.red, size: 16.0),
                                const SizedBox(width: 4.0),
                                Text(
                                  '${widget.meal.readyInMinutes} mins',
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const ImageIcon(
                                  AssetImage('assets/flame.png'),
                                  size: 14.0,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  calories.amount.toString(),
                                  style: const TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  'Cal',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
