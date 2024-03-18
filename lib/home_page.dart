import 'package:adapty_flutter/adapty_flutter.dart';
import 'package:adapty_ui_flutter/adapty_ui_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfit/account_page.dart';
import 'package:cookfit/firestore_database.dart';
import 'package:cookfit/my_custom_adapty_observer.dart';
import 'package:cookfit/search_page.dart';
import 'package:cookfit/user_meals_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTabIndex = 0;
  int? userCredits;
  DateTime? userFillDate;
  DateTime? userAccountDate;
  bool? isDiff;
  AdaptyPaywall? paywall;
  AdaptyUIView? view;
  bool loading = true;

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
      checkCredit();
    });
  }

  Widget _title() {
    return Image.asset(
      'assets/cook_fit_logo.png',
      height: 100.0,
      width: 100.0,
    );
  }

  final List _pages = [
    const SearchPage(),
    const UserMeals(),
    const AccountPage(),
  ];
  @override
  void initState() {
    super.initState();
    checkCredit().whenComplete(
      () {
        endTrialIFNeed().whenComplete(
          () {
            refillCredit();
          },
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkCredit();
    refillCredit();
  }

  Future<void> checkCredit() async {
    await getUserCredits(FirebaseAuth.instance.currentUser!.email!)
        .then((credit) {
      setState(() {
        userCredits = credit;
      });
    });
  }

  Future<DateTime> checkTime() async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    await getUserFillDate(email).then((userFillDateTimeStamp) {
      setState(() {
        userFillDate = DateTime.fromMicrosecondsSinceEpoch(
            userFillDateTimeStamp.microsecondsSinceEpoch);
        userFillDate = userFillDate!.copyWith(hour: 0, minute: 0, second: 0);
      });
    });
    return userFillDate!;
  }

  Future<void> endTrialIFNeed() async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    String userID = FirebaseAuth.instance.currentUser!.uid;
    await getAccountStartDate(email).then((userAcountStartDateTimeStamp) {
      setState(() {
        userAccountDate = DateTime.fromMicrosecondsSinceEpoch(
            userAcountStartDateTimeStamp.microsecondsSinceEpoch);
        userAccountDate = userFillDate!.copyWith(hour: 0, minute: 0, second: 0);
      });
    });
    int diffFromStart = daysBetween(userAccountDate!, DateTime.now());
    if (diffFromStart > 7) {
      await updateUserAccountStatus(userID, 'free');
    }
  }

  Future<void> refillCredit() async {
    String email = FirebaseAuth.instance.currentUser!.email!;
    String userID = FirebaseAuth.instance.currentUser!.uid;
    userFillDate = await checkTime();
    if (userFillDate == null) {
    } else {
      int diff = daysBetween(userFillDate!, DateTime.now());
      if (diff == 1) {
        isDiff = true;
      } else {
        isDiff = false;
      }
      if (isDiff == true) {
        checkUserStatus(email).then((status) async {
          if (status == 'trial') {
            await refillUserCredits(userID, email, 50)
                .then((value) async => await checkCredit());
          } else if (status == 'basic') {
            await refillUserCredits(userID, email, 50)
                .then((value) async => await checkCredit());
          } else if (status == 'premium') {
            await refillUserCredits(userID, email, 100)
                .then((value) async => await checkCredit());
          } else {
            await refillUserCredits(userID, email, 0)
                .then((value) async => await checkCredit());
            try {
              paywall = await Adapty().getPaywall(placementId: "456123");
            } on AdaptyError catch (adaptyError) {
              // handle the error
            } catch (e) {
              // handle the error
            }
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
        });
      }
      setState(() {
        loading = false;
      });
    }
  }

  void paywallViewDidPerformAction(AdaptyUIView view, AdaptyUIAction action) {
    switch (action.type) {
      case AdaptyUIActionType.close:
        view.dismiss();
        break;
      default:
        break;
    }
  }

  Widget remainingCredit() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Credit :',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Text('$userCredits',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.amber)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: _title(),
              actions: [
                remainingCredit(),
                SizedBox(
                  width: 20,
                ),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.search),
                  label: "Search",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.restaurant),
                  label: "Meals",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Account",
                )
              ],
              currentIndex: _selectedTabIndex,
              selectedItemColor: Colors.amber[800],
              onTap: _onItemTapped,
            ),
            body: _pages[_selectedTabIndex],
          );
  }
}

/*
Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: _title(),
        actions: [
          GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const WidgetTree()),
                      (route) => false));
            },
            child: const Icon(
              Icons.logout_outlined,
            ),
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: "Meals",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
          )
        ],
        currentIndex: _selectedTabIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      body: _pages[_selectedTabIndex],
    );
*/