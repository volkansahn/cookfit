import 'package:cookfit/purchase_observer.dart';
import 'package:cookfit/widget_tree.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

Widget _restoreButton() {
  return GestureDetector(
      onTap: () {
        PurchasesObserver().callRestorePurchases();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.remove_shopping_cart),
              SizedBox(
                width: 10,
              ),
              Text('Restore Purchases',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ],
          ),
          Icon(Icons.chevron_right),
        ],
      ));
}

Widget _privacyButton() {
  return GestureDetector(
    onTap: () {
      print('go to privacy & terms');
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.security),
            SizedBox(width: 10),
            Text('Privacy & Terms',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
        Icon(Icons.chevron_right),
      ],
    ),
  );
}

Widget _accountEmail() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          Icon(Icons.email),
          SizedBox(width: 10),
          Text(
            'Email : ',
          ),
        ],
      ),
      Text(FirebaseAuth.instance.currentUser!.email!),
    ],
  );
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 80.0, left: 40, right: 40),
          child: Column(
            children: [
              Image.asset(
                'assets/paywall_image.png', // Replace with your image
                height: 180,
                fit: BoxFit.contain,
              ),
              SingleChildScrollView(
                padding: const EdgeInsets.only(top: 80.0, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _accountEmail(),
                    const SizedBox(height: 30.0),
                    _privacyButton(),
                    const SizedBox(height: 30.0),
                    _restoreButton(),
                    const SizedBox(height: 30.0),
                    Container(
                      margin: const EdgeInsets.all(5),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              // Return the appropriate color based on the button's state
                              if (states.contains(MaterialState.pressed)) {
                                // Return the color when the button is pressed
                                return Color.fromARGB(255, 224, 40, 40);
                              }
                              // Return the default color when the button is not pressed
                              return Color.fromARGB(255, 230, 75, 75);
                            },
                          ),
                        ),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut().then((value) =>
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const WidgetTree()),
                                  (route) => false));
                        },
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18.0,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildAccountInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Navigate to respective setting screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsPage()),
        );
      },
    );
  }

  Widget _buildRefundTile(String orderNumber, String status) {
    return ListTile(
      title: Text(orderNumber),
      subtitle: Text(status),
      onTap: () {
        // Navigate to refund details screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const RefundDetailsPage()),
        );
      },
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: const Center(
        child: Text('Settings Page'),
      ),
    );
  }
}

class RefundDetailsPage extends StatelessWidget {
  const RefundDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refund Details'),
      ),
      body: const Center(
        child: Text('Refund Details Page'),
      ),
    );
  }
}
