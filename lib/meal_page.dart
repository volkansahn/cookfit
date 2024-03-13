import 'dart:io';

import 'package:cookfit/firestore_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../meal.dart';

class MealPage extends StatefulWidget {
  const MealPage({Key? key, required this.mealData}) : super(key: key);
  final Meal mealData;

  @override
  State<MealPage> createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isBookmarked = false;

  InterstitialAd? _interstitialAd;
  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-3940256099942544/4411468910';
  BannerAd? _bannerAdDescription;
  BannerAd? _bannerAdIngredients;
  BannerAd? _bannerAdInstruction;

  bool _isLoaded = false;
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  Future<String> checkStatus() {
    Future<String> userStatus =
        checkUserStatus(FirebaseAuth.instance.currentUser!.email!);
    return userStatus;
  }

  /// Loads a banner ad.
  void loadDescriptionAd() {
    _bannerAdDescription = BannerAd(
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

  void loadIngredientsAd() {
    _bannerAdIngredients = BannerAd(
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

  void loadInstructionAd() {
    _bannerAdInstruction = BannerAd(
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
    _tabController = TabController(length: 3, vsync: this);
    checkStatus().then(
      (value) {
        if (value != 'Premium') {
          loadDescriptionAd();
          loadIngredientsAd();
          loadInstructionAd();
        }
      },
    );
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _tabController.dispose();
    super.dispose();
    _bannerAdDescription?.dispose();
    _bannerAdIngredients?.dispose();
    _bannerAdInstruction?.dispose();
  }

  /// Loads an interstitial ad.
  void _loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          // Called when an ad is successfully received.
          onAdLoaded: (InterstitialAd ad) {
            ad.fullScreenContentCallback = FullScreenContentCallback(
                // Called when the ad showed the full screen content.
                onAdShowedFullScreenContent: (ad) {},
                // Called when an impression occurs on the ad.
                onAdImpression: (ad) {},
                // Called when the ad failed to show full screen content.
                onAdFailedToShowFullScreenContent: (ad, err) {
                  ad.dispose();
                },
                // Called when the ad dismissed full screen content.
                onAdDismissedFullScreenContent: (ad) {
                  ad.dispose();
                },
                // Called when a click is recorded for an ad.
                onAdClicked: (ad) {});

            // Keep a reference to the ad so you can show it later.
            _interstitialAd = ad;
            _showInterstitialAd();
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (LoadAdError error) {
            // ignore: avoid_print
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  void _showInterstitialAd() {
    _interstitialAd?.show();
  }

  void _toggleBookmark() {
    if (_isBookmarked == false) {
      checkUserStatus(FirebaseAuth.instance.currentUser!.email!).then(
        (value) {
          if (value != 'Premium') {
            _loadInterstitialAd();
          }
        },
      );
      addBookmark(FirebaseAuth.instance.currentUser?.uid ?? '',
              widget.mealData.id.toString(), widget.mealData)
          .then((value) {
        setState(() {
          _isBookmarked = true;
        });
      });
    } else {
      deleteBookmark(
              FirebaseAuth.instance.currentUser?.uid ?? '', widget.mealData.id!)
          .then((value) {
        setState(() {
          _isBookmarked = false;
        });
      });
    }
  }

  Color _calculateButtonColor(String? imageUrl) {
    const Color defaultColor = Colors.white; // Default color for the button
    if (imageUrl == null || imageUrl.isEmpty) {
      return defaultColor; // Return default color if image URL is null or empty
    }

    final double luminance = Colors.black.computeLuminance();
    const double threshold = 0.5; // Adjust this threshold as needed

    // Check if the background color's luminance is below the threshold
    if (luminance < threshold) {
      // If background is dark, return the default color
      return defaultColor;
    } else {
      // If background is light, return a dark color for better contrast
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // SliverAppBar for the Hero image
              SliverAppBar(
                expandedHeight: 200.0, // Adjust the height as needed
                flexibleSpace: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: 'meal_image',
                      child: Image.network(
                        widget.mealData.image ?? '',
                        fit: BoxFit
                            .cover, // Ensure the image covers the entire area
                      ),
                    ),
                    Positioned(
                      bottom: 10.0,
                      right: 10.0,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: _toggleBookmark,
                          icon: _isBookmarked
                              ? Icon(
                                  Icons.bookmark,
                                  weight: 800,
                                  color: _calculateButtonColor(
                                      widget.mealData.image),
                                  size: 36.0,
                                )
                              : Icon(Icons.bookmark_border,
                                  weight: 800,
                                  color: _calculateButtonColor(
                                      widget.mealData.image),
                                  size: 36.0),
                        ),
                      ),
                    )
                  ],
                ),
                iconTheme: IconThemeData(
                    size: 36.0,
                    weight: 800,
                    color: _calculateButtonColor(widget.mealData
                        .image)), // Change the color of the back button
              ),

              // SliverPersistentHeader for the TabBar
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  child: Container(
                    color: Colors.white, // Set background color of TabBar
                    child: TabBar(
                      controller: _tabController,
                      onTap: (index) {},
                      tabs: const [
                        Tab(
                            icon: Icon(
                          Icons.summarize_outlined,
                          color: Colors.amber,
                        )),
                        Tab(
                            icon: Icon(Icons.local_grocery_store,
                                color: Colors.amber)),
                        Tab(
                          icon: Icon(Icons.food_bank_rounded,
                              color: Colors.amber),
                        ),
                      ],
                    ),
                  ),
                ),
                pinned: true, // Make the TabBar stick to the top
                floating: true, // Allow the TabBar to slide in and out
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildDetailsSection(),
              _buildIngredientsSection(),
              _buildInstructionsSection(),
              //_buildNutritionSection(),
            ],
          ),
        ),
      ),
    );
  }

  // Build each section's content here
  Widget _buildDetailsSection() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      widget.mealData.title ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: HtmlWidget(
                justifyText(widget.mealData.summary ?? ''),
                textStyle:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w300),
              ),
            ),
          ),
          // Cuisines (if available)
          if (widget.mealData.cuisines!.isNotEmpty) ...[
            const Align(
              alignment: Alignment.topCenter,
              child: Text('Cuisines',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.amber)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: widget.mealData.cuisines!
                      .map(
                        (cuisine) => Chip(
                          side: BorderSide.none,
                          elevation: 1.0,
                          label: Text(
                            cuisine.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                          backgroundColor: Colors.amber,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
          // Diets (if available)
          if (widget.mealData.diets!.isNotEmpty) ...[
            const Align(
              alignment: Alignment.topCenter,
              child: Text('Diets',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Colors.green)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.topCenter,
                child: Wrap(
                  runAlignment: WrapAlignment.center,
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: widget.mealData.diets!
                      .map(
                        (diet) => Chip(
                          side: BorderSide.none,
                          elevation: 1.0,
                          label: Text(
                            diet.toUpperCase(),
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                          backgroundColor: Colors.green,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
          SizedBox(
            height: 10,
          ),
          if (_bannerAdDescription != null) ...[
            StatefulBuilder(
              builder: (context, setState) => Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: SizedBox(
                    width: _bannerAdDescription!.size.width.toDouble(),
                    height: _bannerAdDescription!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAdDescription!),
                  ),
                ),
              ),
            )
          ],
        ],
      ),
    );
  }

  String createSummary(str) {
    int index = 0;
    List<int> indexes = [];
    while (index != -1) {
      index = str.indexOf('.', index);
      if (index != -1) {
        indexes.add(index);
        index++;
      }
    }
    String result = str.substring(0, indexes[1] + 1);

    return result;
  }

  String justifyText(str) {
    String summaryHtml = '''
  <div style="text-align: center;">
    ${createSummary(widget.mealData.summary ?? '')}
  </div>
''';
    return summaryHtml;
  }

  Widget _buildIngredientsSection() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_bannerAdIngredients != null) ...[
            StatefulBuilder(
              builder: (context, setState) => Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: SizedBox(
                    width: _bannerAdIngredients!.size.width.toDouble(),
                    height: _bannerAdIngredients!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAdIngredients!),
                  ),
                ),
              ),
            )
          ],
          ListView.builder(
            shrinkWrap: true,
            physics:
                const NeverScrollableScrollPhysics(), // Prevent nested scrolling
            itemCount: widget.mealData.nutrition!.ingredients?.length,
            itemBuilder: (context, index) {
              final ingredient = widget.mealData.nutrition!.ingredients?[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      color: Colors.amber,
                      size: 12,
                    ),
                    const SizedBox(width: 12.0),
                    Flexible(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${ingredient?.amount} ${ingredient?.unit} ',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Text('${ingredient!.name}',
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                                style: const TextStyle(
                                    fontSize: 18, letterSpacing: 1.15)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionsSection() {
    String baseURL = 'https://spoonacular.com/cdn/ingredients_100x100/';
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_bannerAdInstruction != null) ...[
            StatefulBuilder(
              builder: (context, setState) => Align(
                alignment: Alignment.bottomCenter,
                child: SafeArea(
                  child: SizedBox(
                    width: _bannerAdInstruction!.size.width.toDouble(),
                    height: _bannerAdInstruction!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAdInstruction!),
                  ),
                ),
              ),
            )
          ],
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.mealData.analyzedInstructions?[0].steps?.length,
            itemBuilder: (context, index) {
              final instruction =
                  widget.mealData.analyzedInstructions![0].steps?[index];
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${index + 1}.',
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber)),
                    Expanded(
                      child: Column(
                        children: [
                          Text(instruction!.step ?? '',
                              style: const TextStyle(
                                  fontSize: 18, color: Colors.black)),
                          const SizedBox(
                            height: 10,
                          ),
                          Wrap(
                            spacing: 15.0,
                            children: instruction.ingredients!.map(
                              (ingredientItem) {
                                if (ingredientItem.image != null &&
                                    ingredientItem.image!.isNotEmpty) {
                                  return Image.network(
                                    baseURL + ingredientItem.image!,
                                    width: 90,
                                    height: 90,
                                    fit: BoxFit.contain,
                                  );
                                } else {
                                  return const SizedBox
                                      .shrink(); // Skip adding the image
                                }
                              },
                            ).toList(),
                          ),
                        ],
                      ),
                    ),
                    // Add a checkbox or interactive element for marking steps as completed
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

/* NUTRITION PART

  Widget _buildNutritionSection() {
    String mealID = widget.mealData.id.toString();
    String imgLink =
        'https://api.spoonacular.com/recipes/$mealID/nutritionLabel.png?apiKey=1ed8f4808298475983d634e9d6cb1373';
    bool isImageExpanded = false;

    return Center(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isImageExpanded = !isImageExpanded;
          });
        },
        child: isImageExpanded
            ? Container(
                color: Colors.black,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        isImageExpanded = false;
                      });
                    },
                    child: Image.network(
                      imgLink,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              )
            : Image.network(
                imgLink,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
*/
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({required this.child});

  final Widget child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 50.0;

  @override
  double get minExtent => 50.0;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
