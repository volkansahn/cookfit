import 'package:cookfit/account_page.dart';
import 'package:cookfit/search_page.dart';
import 'package:cookfit/user_meals_page.dart';
import 'package:cookfit/widget_tree.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTabIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedTabIndex = index;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
  }
}
