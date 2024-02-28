import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:cookfit/firestore_database.dart';
import 'package:cookfit/meal_list_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:group_button/group_button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String? _cuisineDropValue;
  String? _mealDropValue;
  String? _dietTypeDropValue;
  bool isChecked = false;
  final _intoleranceController = GroupButtonController();
  final _cuisineController = GroupButtonController();
  final _mealController = GroupButtonController();
  final _dietTypeController = GroupButtonController();
  final List<String> _ingredientButtons = [];
  final List<String> _selectedIntolerances = [];
  final List<int> _selectedIntolerancesIndexes = [];
  List<dynamic> userBookmarks = [];
  List<int> userBookmarkList = [];
  bool _showAllCuisine = false;
  bool _showAllMealType = false;
  bool _showAllDietType = false;
  bool _showAllIntolerance = false;
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  void initState() {
    super.initState();

    checkStatus().then(
      (value) {
        if (value != 'Premium') {
          print(value);
          loadAd();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
  }

  Future<String> checkStatus() {
    Future<String> userStatus =
        checkUserStatus(FirebaseAuth.instance.currentUser!.email!);
    return userStatus;
  }

  /// Loads a banner ad.
  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<List<int>> getUserBookmarks() async {
    userBookmarks = await getUserBookmarkedMeals(
        FirebaseAuth.instance.currentUser?.uid ?? '');
    List<int> mealList = [];

    for (int i = 0; i < userBookmarks.length; i++) {
      mealList.add((userBookmarks[i]['id']));
    }
    return mealList;
  }

  String baseURL =
      'https://api.spoonacular.com/recipes/complexSearch?instructionsRequired=true&addRecipeNutrition=true&apiKey=1ed8f4808298475983d634e9d6cb1373';

  Widget _letsCookButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.all(5),
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                // Return the appropriate color based on the button's state
                if (states.contains(MaterialState.pressed)) {
                  // Return the color when the button is pressed
                  return const Color.fromARGB(255, 37, 107, 39);
                }
                // Return the default color when the button is not pressed
                return const Color.fromARGB(255, 86, 207, 90);
              },
            ),
          ),
          onPressed: () async {
            if (_ingredientButtons.isNotEmpty) {
              baseURL = '$baseURL&includeIngredients=';
              if (_ingredientButtons.length == 1) {
                baseURL = baseURL + _ingredientButtons[0];
              } else {
                for (int i = 0; i < _ingredientButtons.length; i++) {
                  baseURL = '$baseURL${_ingredientButtons[i]},';
                }
                baseURL = baseURL.substring(0, baseURL.length - 1);
              }
            }
            if (_cuisineDropValue != null) {
              baseURL = '$baseURL&cuisine=$_cuisineDropValue';
            }
            if (_mealDropValue != null) {
              baseURL = '$baseURL&type=$_mealDropValue';
            }
            if (_dietTypeDropValue != null) {
              baseURL = '$baseURL&diet=$_dietTypeDropValue';
            }
            if (_selectedIntolerances.isNotEmpty) {
              baseURL = '$baseURL&intolerances=';
              if (_selectedIntolerances.length == 1) {
                baseURL = baseURL + _selectedIntolerances[0];
              } else {
                for (int i = 0; i < _selectedIntolerances.length; i++) {
                  baseURL = '$baseURL${_selectedIntolerances[i]},';
                }
                baseURL = baseURL.substring(0, baseURL.length - 1);
              }
            }
            String fetchURL = baseURL;

            setState(() {
              baseURL =
                  'https://api.spoonacular.com/recipes/complexSearch?instructionsRequired=true&addRecipeNutrition=true&apiKey=1ed8f4808298475983d634e9d6cb1373';
              _cuisineController.unselectAll();
              _mealController.unselectAll();
              _dietTypeController.unselectAll();
              _cuisineDropValue = null;
              _mealDropValue = null;
              _dietTypeDropValue = null;
              _intoleranceController
                  .unselectIndexes(_selectedIntolerancesIndexes);
              _ingredientButtons.clear();
              _selectedIntolerances.clear();
              _selectedIntolerancesIndexes.clear();
            });
            bool hasCredit = await getAndUpdateSearchCredit(
              FirebaseAuth.instance.currentUser?.uid ?? '',
              FirebaseAuth.instance.currentUser?.email ?? '',
            );
            if (hasCredit) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealListPage(
                    fetchURL: fetchURL,
                    userBookmarks: userBookmarkList,
                  ),
                ),
              );
            } else {
              print('Put paywall here');
            }
          },
          child: const Text(
            "Let's Cook",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _showIngredientOptionsBottomSheet(
      BuildContext context, String ingredient) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                // Close the bottom sheet
                Navigator.pop(context);
                // Show the text input dialog for editing the ingredient
                _showEditIngredientDialog(context, ingredient);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                // Close the bottom sheet
                Navigator.pop(context);
                // Delete the ingredient
                setState(() {
                  _ingredientButtons.remove(ingredient);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () {
                // Close the bottom sheet
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditIngredientDialog(BuildContext context, String ingredient) {
    showTextInputDialog(
      context: context,
      title: "Edit Ingredient",
      message: 'Enter New Ingredient',
      okLabel: "Ok",
      cancelLabel: "Cancel",
      barrierDismissible: false,
      textFields: [
        DialogTextField(
          keyboardType: TextInputType.text,
          initialText: ingredient,
        ),
      ],
    ).then((value) {
      if (value != null && value.isNotEmpty) {
        setState(() {
          // Replace the edited ingredient in the list
          final index = _ingredientButtons.indexOf(ingredient);
          if (index != -1) {
            _ingredientButtons[index] = value[0].toString();
          }
        });
      }
    });
  }

  onDispose() {
    baseURL = "";
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Ingredients",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          // Return the appropriate color based on the button's state
                          if (states.contains(MaterialState.pressed)) {
                            // Return the color when the button is pressed
                            return const Color.fromARGB(255, 37, 107, 39);
                          }
                          // Return the default color when the button is not pressed
                          return const Color.fromARGB(255, 86, 207, 90);
                        },
                      ),
                    ),
                    onPressed: () {
                      showTextInputDialog(
                        context: context,
                        title: "Ingredient",
                        message: 'Enter Ingredient Here',
                        okLabel: "Ok",
                        cancelLabel: "Cancel",
                        barrierDismissible: false,
                        textFields: [
                          const DialogTextField(
                            keyboardType: TextInputType.number,
                            hintText: 'Lelegume',
                          )
                        ],
                      ).then((value) {
                        setState(() {
                          _ingredientButtons.add(value![0].toString());
                        });
                      });
                    },
                    child: const Text(
                      "Add",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Center(
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: _ingredientButtons
                      .map(
                        (ingredient) => GestureDetector(
                          onTap: () {
                            // Show bottom sheet when the ingredient chip is tapped
                            _showIngredientOptionsBottomSheet(
                                context, ingredient);
                          },
                          child: Chip(
                            side: BorderSide.none,
                            elevation: 0.5,
                            label: Text(
                              ingredient.toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            backgroundColor: Colors.amber,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const Divider(
                thickness: 1.0,
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cuisine Selection',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showAllCuisine = !_showAllCuisine;
                          });
                        },
                        child: Text(
                          _showAllCuisine ? 'See Less' : 'See More',
                          style: const TextStyle(
                            color: Colors.blue, // Change color as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GroupButton(
                    options: GroupButtonOptions(
                      borderRadius: BorderRadius.circular(10),
                      unselectedColor: const Color.fromARGB(255, 233, 226, 203),
                      unselectedTextStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      selectedColor: Colors.amber,
                      selectedTextStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    isRadio: true,
                    enableDeselect: true,
                    controller: _cuisineController,
                    onSelected: (value, index, isSelected) {
                      setState(() {
                        _cuisineDropValue = value;
                      });
                    },
                    buttons: _showAllCuisine
                        ? [
                            'African',
                            'Asian',
                            'American',
                            'British',
                            'Cajun',
                            'Caribbean',
                            'Chinese',
                            'Eastern European',
                            'European',
                            'French',
                            'German',
                            'Greek',
                            'Indian',
                            'Irish',
                            'Italian',
                            'Japanese',
                            'Jewish',
                            'Korean',
                            'Latin American',
                            'Mediterranean',
                            'Mexican',
                            'Middle Eastern',
                            'Nordic',
                            'Southern',
                            'Spanish',
                            'Thai',
                            'Vietnamese'
                          ]
                        : [
                            'African',
                            'Asian',
                            'American'
                          ], // Show only 3 buttons initially
                  ),
                ],
              ),
              const Divider(
                thickness: 1.0,
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Meal Type Selection',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showAllMealType = !_showAllMealType;
                          });
                        },
                        child: Text(
                          _showAllMealType ? 'See Less' : 'See More',
                          style: const TextStyle(
                            color: Colors.blue, // Change color as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GroupButton(
                    options: GroupButtonOptions(
                      borderRadius: BorderRadius.circular(10),
                      unselectedColor: const Color.fromARGB(255, 233, 226, 203),
                      unselectedTextStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      selectedColor: Colors.amber,
                      selectedTextStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    isRadio: true,
                    enableDeselect: true,
                    controller: _mealController,
                    onSelected: (value, index, isSelected) {
                      setState(() {
                        _mealDropValue = value;
                      });
                    },
                    buttons: _showAllMealType
                        ? const [
                            "Main Course",
                            "Side Dish",
                            "Dessert",
                            "Appetizer",
                            "Salad",
                            "Bread",
                            "Breakfast",
                            "Soup",
                            "Beverage",
                            "Sauce",
                            "Marinade",
                            "Fingerfood",
                            "Snack",
                            "Drink"
                          ]
                        : ["Main Course", "Side Dish"],
                  ),
                ],
              ),
              const Divider(
                thickness: 1.0,
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Diet Type Selection',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showAllDietType = !_showAllDietType;
                          });
                        },
                        child: Text(
                          _showAllDietType ? 'See Less' : 'See More',
                          style: const TextStyle(
                            color: Colors.blue, // Change color as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GroupButton(
                    options: GroupButtonOptions(
                      borderRadius: BorderRadius.circular(10),
                      unselectedColor: const Color.fromARGB(255, 233, 226, 203),
                      unselectedTextStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      selectedColor: Colors.amber,
                      selectedTextStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    isRadio: true,
                    enableDeselect: true,
                    controller: _dietTypeController,
                    onSelected: (value, index, isSelected) {
                      setState(() {
                        _dietTypeDropValue = value;
                      });
                    },
                    buttons: _showAllDietType
                        ? const [
                            "Gluten Free",
                            "Ketogenic",
                            "Vegetarian",
                            "Lacto-Vegetarian",
                            "Ovo-Vegetarian",
                            "Vegan",
                            "Pescetarian",
                            "Paleo",
                            "Primal",
                            "Low FODMAP",
                            "Whole30"
                          ]
                        : ["Gluten Free", "Ketogenic"],
                  ),
                ],
              ),
              const Divider(
                thickness: 1.0,
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Intolerances Selection',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _showAllIntolerance = !_showAllIntolerance;
                          });
                        },
                        child: Text(
                          _showAllIntolerance ? 'See Less' : 'See More',
                          style: const TextStyle(
                            color: Colors.blue, // Change color as needed
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  GroupButton(
                    options: GroupButtonOptions(
                      borderRadius: BorderRadius.circular(10),
                      unselectedColor: const Color.fromARGB(255, 233, 226, 203),
                      unselectedTextStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      selectedColor: Colors.amber,
                      selectedTextStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    isRadio: false,
                    controller: _intoleranceController,
                    onSelected: (value, index, isSelected) {
                      _selectedIntolerances.add(value);
                      _selectedIntolerancesIndexes.add(index);
                    },
                    buttons: _showAllIntolerance
                        ? const [
                            'Dairy',
                            'Egg',
                            'Gluten',
                            'Grain',
                            'Peanut',
                            'Seafood',
                            'Seasame',
                            'Shellfish',
                            'Soy',
                            'Sulfite',
                            'Tree Nut',
                            'Wheat'
                          ]
                        : ['Dairy', 'Egg', 'Gluten'],
                  ),
                ],
              ),
              const Divider(
                thickness: 1.0,
              ),
              const SizedBox(height: 20),
              if (_bannerAd != null) ...[
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    child: SizedBox(
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                    ),
                  ),
                )
              ],
              _letsCookButton(),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
