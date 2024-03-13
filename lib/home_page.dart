import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfit/account_page.dart';
import 'package:cookfit/firestore_database.dart';
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
  Timestamp? userRegisterDate;
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
    checkCredit();
    checkTime();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checkCredit();
    checkTime();
  }

  void checkCredit() {
    getUserCredits(FirebaseAuth.instance.currentUser!.email!).then((credit) {
      setState(() {
        userCredits = credit;
      });
    });
  }

  void checkTime() {
    String email = FirebaseAuth.instance.currentUser!.email!;
    String userID = FirebaseAuth.instance.currentUser!.uid;
    getUserRegisterDate(email).then((userRegisterDate) {
      setState(() {
        userRegisterDate = userRegisterDate;
        var date = DateTime.fromMicrosecondsSinceEpoch(
            userRegisterDate.microsecondsSinceEpoch);
        final twelve = date.copyWith(hour: 0, minute: 0, second: 0);
        int diff = daysBetween(twelve, DateTime.now());
        checkUserStatus(email).then((status) {
          if (status == 'trial') {
            //refillUserCredits(userID, email)
          }
        });
      });
    });
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
    return Scaffold(
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