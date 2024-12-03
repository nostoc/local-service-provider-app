import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart'; // For opening phone dialer
import 'package:local_service_provider_app/utils/colors.dart';

class HandymanProfileView extends StatelessWidget {
  final String handymanId;

  const HandymanProfileView({super.key, required this.handymanId});

  Future<DocumentSnapshot> fetchHandymanProfile(String handymanId) {
    return FirebaseFirestore.instance
        .collection('handymen')
        .doc(handymanId)
        .get();
  }

  Future<void> _makePhoneCall(BuildContext context, String phone) async {
    // Sanitize phone number (remove spaces, brackets, dashes)
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');

    // Ensure the phone number starts with a valid prefix
    if (!cleanPhone.startsWith('+') && !cleanPhone.startsWith('0')) {
      cleanPhone = '+254$cleanPhone'; // Assume Kenyan number if no prefix
    }

    final Uri callUri = Uri.parse('tel:$cleanPhone');

    try {
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      } else {
        // Show a user-friendly error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unable to make a call to $cleanPhone'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('Phone call launch error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: const Text(
          "Handyman Profile",
          style: TextStyle(color: mainTextColor),
        ),
        backgroundColor: whiteColor,
        iconTheme: const IconThemeData(color: mainTextColor),
        elevation: 0,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchHandymanProfile(handymanId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text(
                "Handyman profile not found.",
                style: TextStyle(fontSize: 18.0, color: mainTextColor),
              ),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final name = data['handyManName'] ?? "Unknown";
          final phone = data['handyManPhone'] ?? "N/A";
          final email = data['handyManEmail'] ?? "N/A";
          final address = data['handyManAddress'] ?? "No Address";
          final jobTitle = data['handyManJobTitle'] ?? "No Job Title";
          final imageUrl = data['handyManImageUrl'] ??
              'https://i.stack.imgur.com/l60Hf.png'; // Default image

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32.0),
                    CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage(imageUrl),
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: mainTextColor,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      jobTitle,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 60.0),
                    _buildContactInfo(Icons.phone, phone),
                    const SizedBox(height: 12.0),
                    _buildContactInfo(Icons.email, email),
                    const SizedBox(height: 12.0),
                    _buildContactInfo(Icons.location_on, address),
                    const SizedBox(height: 60.0),
                    ElevatedButton.icon(
                      onPressed: () => _makePhoneCall(context, phone),
                      icon: const Icon(Icons.call),
                      label: Text("Call $name"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainTextColor,
                        foregroundColor: whiteColor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 32.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String info) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: mainTextColor, size: 18),
        const SizedBox(width: 12.0),
        Expanded(
          child: Text(
            info,
            style: const TextStyle(
              fontSize: 16.0,
              color: mainTextColor,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
