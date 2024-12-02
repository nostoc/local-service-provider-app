import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_service_provider_app/utils/colors.dart';

class UserProfileView extends StatelessWidget {
  final String userId;
  final String userType; // Either "Visitor" or "Handyman"

  const UserProfileView({
    super.key,
    required this.userId,
    required this.userType,
  });

  Future<DocumentSnapshot> fetchUserProfile(String userId) {
    return FirebaseFirestore.instance
        .collection(userType == "Visitor" ? 'visitors' : 'handymen')
        .doc(userId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "$userType Profile",
          style: const TextStyle(color: mainTextColor),
        ),
        backgroundColor: whiteColor,
        iconTheme: const IconThemeData(color: mainTextColor),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: fetchUserProfile(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text(
                "$userType profile not found.",
                style: const TextStyle(fontSize: 18.0, color: mainTextColor),
              ),
            );
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final name = data['handyManName'] ?? "Unknown";
          final email = FirebaseAuth.instance.currentUser?.email ?? "No Email";
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
                  const SizedBox(height: 16.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.email, color: mainTextColor),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          email,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: mainTextColor,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32.0),
                  // ElevatedButton.icon(
                  //   onPressed: () {
                  //     // Handle password update or email change navigation
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => UpdatePasswordScreen(),
                  //       ),
                  //     );
                  //   },
                  //   icon: const Icon(Icons.lock_reset),
                  //   label: const Text("Update Password"),
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.blue,
                  //     foregroundColor: whiteColor,
                  //     padding: const EdgeInsets.symmetric(
                  //       vertical: 12.0,
                  //       horizontal: 24.0,
                  //     ),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(8.0),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 16.0),
                  ElevatedButton.icon(
                    onPressed: () async {
                      // Sign out
                      await FirebaseAuth.instance.signOut();
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text("Logout"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
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
