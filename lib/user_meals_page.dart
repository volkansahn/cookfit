import 'dart:io';

import 'package:cookfit/firestore_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../meal.dart';
import 'meal_card.dart';
import 'package:http/http.dart' as http;

class UserMeals extends StatefulWidget {
  const UserMeals({Key? key}) : super(key: key);

  @override
  State<UserMeals> createState() => _UserMealsState();
}

class _UserMealsState extends State<UserMeals> {
  bool listLoading = true;
  var client = http.Client();
  List<Meal> userBookmarkList = [];
  List<int> mealList = [];
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

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
  void initState() {
    super.initState();
    getUserBookmarks().then((List<dynamic> userBookmarks) {
      userBookmarkList =
          userBookmarks.map((bookmark) => Meal.fromMap(bookmark)).toList();
      setState(() {
        listLoading = false;
      });
    });
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUserBookmarks().then((List<dynamic> userBookmarks) {
      userBookmarkList =
          userBookmarks.map((bookmark) => Meal.fromMap(bookmark)).toList();
      setState(() {
        listLoading = false;
      });
    });
  }

  Future<List<dynamic>> getUserBookmarks() async {
    List<dynamic> userBookmarks = await getUserBookmarkedMeals(
        FirebaseAuth.instance.currentUser?.uid ?? '');

    for (int i = 0; i < userBookmarks.length; i++) {
      mealList.add((userBookmarks[i]['id']));
    }
    return userBookmarks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        child: listLoading
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
                  SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: userBookmarkList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: MealCard(
                            meal: userBookmarkList[index],
                            userBookmarks: mealList,
                            isBookmarked: true,
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
