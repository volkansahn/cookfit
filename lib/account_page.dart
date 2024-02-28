import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Account Information'),
            _buildAccountInfoRow(
                'Email', FirebaseAuth.instance.currentUser!.email!),
            const SizedBox(height: 30.0),
            _buildSectionHeader('Settings'),
            _buildSettingTile(Icons.security, 'Privacy & Security'),
            _buildSettingTile(Icons.payment, 'Payment'),
            _buildSettingTile(Icons.settings, 'Settings'),
            const SizedBox(height: 30.0),
            _buildSectionHeader('Refunds'),
            _buildRefundTile('Order #1234', 'Refund requested'),
            _buildRefundTile('Order #5678', 'Refund in progress'),
            _buildRefundTile('Order #91011', 'Refund completed'),
            const SizedBox(height: 30.0),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Logout'),
              ),
            ),
          ],
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
