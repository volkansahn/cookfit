import 'dart:convert';
import 'dart:io';
import 'package:cookfit/firestore_database.dart';
import 'package:cookfit/home_page.dart';
import 'package:cookfit/meal_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import '../meal.dart';

class MealListPage extends StatefulWidget {
  const MealListPage(
      {Key? key,
      required this.fetchURL,
      required this.userBookmarks,
      required this.meals})
      : super(key: key);
  final List<Meal> meals;

  final String fetchURL;
  final List<int> userBookmarks;

  @override
  State<MealListPage> createState() => _MealListPageState();
}

class _MealListPageState extends State<MealListPage> {
  bool loading = true;
  final String url =
      'https://api.spoonacular.com/recipes/complexSearch?intolerances=Dairy,Egg&cuisine=Italian&diet=Vegetarian&includeIngredients=onion,tomato,lelegumes&instructionsRequired=true&addRecipeNutrition=true&number=5&apiKey=1ed8f4808298475983d634e9d6cb1373';
  var client = http.Client();
  List<Meal> _meals = [];
  List<Meal> userBookmarkList = [];
  List<int> mealList = [];
  bool isBookmarked = false;
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  int? userCredits;
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-8275958678374376/8820176569'
      : 'ca-app-pub-3940256099942544/2934735716';

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
  void initState() {
    super.initState();
    checkStatus().then(
      (value) {
        if (value != 'premium') {
          print(value);
          loadAd();
        }
      },
    );
    if (widget.fetchURL != 'no') {
      fetchData();
    } else if (widget.fetchURL == 'no') {
      setState(() {
        loading = false;
        _meals = widget.meals;
      });
    }
    getUserBookmarks().then((List<dynamic> userBookmarks) {
      userBookmarkList =
          userBookmarks.map((bookmark) => Meal.fromMap(bookmark)).toList();
    });
    checkCredit();
  }

  @override
  void didUpdateWidget(covariant MealListPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // id changed in the widget, I need to make a new API call
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserBookmarks().then((List<dynamic> userBookmarks) {
      userBookmarkList =
          userBookmarks.map((bookmark) => Meal.fromMap(bookmark)).toList();
    });
    checkCredit();
  }

  void checkCredit() {
    getUserCredits(FirebaseAuth.instance.currentUser!.email!).then((credit) {
      setState(() {
        userCredits = credit;
      });
    });
  }

  Widget remainingCredit() {
    return Container(
      child: Row(
        children: [
          Text('Credit :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text('$userCredits',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.amber)),
        ],
      ),
    );
  }

  Future<List<dynamic>> getUserBookmarks() async {
    List<dynamic> userBookmarks = await getUserBookmarkedMeals(
        FirebaseAuth.instance.currentUser?.uid ?? '');

    for (int i = 0; i < userBookmarks.length; i++) {
      mealList.add((userBookmarks[i]['id']));
    }
    return userBookmarks;
  }

  Future<List<Meal>> fetchData() async {
    print(widget.fetchURL);
    http.Response response = await client.get(Uri.parse(widget.fetchURL));

    // Connection Ok
    if (response.statusCode == 200) {
      Map<String, dynamic> responseJson =
          json.decode(response.body) as Map<String, dynamic>;
      final results = responseJson['results'] as List<dynamic>;
      final resultList = results
          .whereType<Map<String, dynamic>>()
          .map((mealJson) => Meal.fromJson(mealJson))
          .toList();

      setState(() {
        _meals = resultList;
        loading = false;
      });

      return resultList;
    } else {
      throw ('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal List"),
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            isFromOnboard: false,
                          )),
                  (Route<dynamic> route) => false);
            },
            child: Icon(Icons.arrow_back)),
        actions: [
          remainingCredit(),
          SizedBox(
            width: 20,
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
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
                  Expanded(
                    child: ListView.builder(
                      itemCount: _meals.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (mealList.contains(_meals[index].id)) {
                          isBookmarked = true;
                        } else {
                          isBookmarked = false;
                        }
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: MealCard(
                            meal: _meals[index],
                            userBookmarks: widget.userBookmarks,
                            isBookmarked: isBookmarked,
                            meals: _meals,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
