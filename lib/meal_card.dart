import 'package:cookfit/firestore_database.dart';
import 'package:cookfit/meal_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../meal.dart';

class MealCard extends StatefulWidget {
  final Meal meal;
  final List<int> userBookmarks;
  final bool isBookmarked;

  const MealCard(
      {super.key,
      required this.meal,
      required this.userBookmarks,
      required this.isBookmarked});

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> {
  late Nutrients calories;

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
                builder: (context) => MealPage(mealData: widget.meal)),
          );
        } else {
          print('Put paywall here');
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
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const ImageIcon(
                                  AssetImage('assets/flame.png'),
                                  size: 16.0,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  calories.amount.toString(),
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                const Text(
                                  'Cal',
                                  style: TextStyle(
                                    fontSize: 16.0,
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
