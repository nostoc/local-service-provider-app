import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_service_provider_app/utils/colors.dart';
import 'package:local_service_provider_app/views/handyman/handy_man_profile_view.dart';

class HandymenListScreen extends StatelessWidget {
  final String category;

  const HandymenListScreen({super.key, required this.category});

  Stream<QuerySnapshot> fetchHandymenByCategory(String category) {
    return FirebaseFirestore.instance
        .collection('handymen')
        .where('handyManJobTitle', isEqualTo: category)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: Text(
          "${category}s",
          style: const TextStyle(
            color: mainTextColor,
          ),
        ),
        backgroundColor: whiteColor,
        iconTheme: const IconThemeData(
            color: mainTextColor), // Adjust app bar icon color
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: fetchHandymenByCategory(category),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No $category available.",
                style: const TextStyle(fontSize: 18.0, color: mainTextColor),
              ),
            );
          }

          final handymen = snapshot.data!.docs;

          return ListView.builder(
            itemCount: handymen.length,
            itemBuilder: (context, index) {
              final handyman = handymen[index];
              final name = handyman['handyManName'] ?? "Unknown";
              final phone = handyman['handyManPhone'] ?? "N/A";
              final address = handyman['handyManAddress'] ?? "No Address";
              final imageUrl = handyman['handyManImageUrl'] ??
                  'https://i.stack.imgur.com/l60Hf.png'; // Default image

              return Card(
                color: whiteColor,
                elevation: 8.0, // Slightly more pronounced shadow
                margin: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0), 
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0), 
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30, // Slightly smaller radius for balance
                      backgroundImage: NetworkImage(imageUrl),
                    ),
                    title: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold, // Bold for emphasis
                        color: mainTextColor,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          phone,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey, // Lighter color for phone
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          address,
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    contentPadding: EdgeInsets.zero, // Remove extra padding
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HandymanProfileView(
                            handymanId: handyman.id, // Pass the document ID
                          ),
                        ),
                      );
                    },

                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
