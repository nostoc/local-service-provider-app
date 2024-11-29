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

  Future<void> _makePhoneCall(String phone) async {
    if (phone.isEmpty || phone == "N/A") {
      debugPrint("Invalid phone number: $phone");
      return;
    }
    final Uri callUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      debugPrint("Could not launch $callUri");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Handyman Profile",
          style: TextStyle(color: mainTextColor),
        ),
        backgroundColor: whiteColor,
        iconTheme: const IconThemeData(color: mainTextColor),
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
          final address = data['handyManAddress'] ?? "No Address";
          final jobTitle = data['handyManJobTitle'] ?? "No Job Title";
          final imageUrl = data['handyManImageUrl'] ??
              'https://i.stack.imgur.com/l60Hf.png'; // Default image

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40.0),
                  CircleAvatar(
                    radius: 100,
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
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.phone, color: mainTextColor),
                      const SizedBox(width: 8.0),
                      Text(
                        phone,
                        style: const TextStyle(
                          fontSize: 16.0,
                          color: mainTextColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on, color: mainTextColor),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          address,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: mainTextColor,
                          ),
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton.icon(
                    onPressed: () => _makePhoneCall(phone),
                    icon: const Icon(Icons.call),
                    label: Text("Call $name"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainTextColor,
                      foregroundColor: whiteColor,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12.0,
                        horizontal: 24.0,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
