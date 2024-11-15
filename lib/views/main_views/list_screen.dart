import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_service_provider_app/utils/colors.dart';

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
      appBar: AppBar(
        title: Text("$category Handymen"),
        backgroundColor: mainTextColor,
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
                  'https://i.stack.imgur.com/l60Hf.png';

              return Card(
                elevation: 4.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                  title: Text(name, style: const TextStyle(fontSize: 18.0)),
                  subtitle: Text("📞 $phone\n📍 $address"),
                  isThreeLine: true,
                  onTap: () {
                    // Optional: Add more functionality on tap
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
