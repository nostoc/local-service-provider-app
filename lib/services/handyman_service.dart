import 'package:cloud_firestore/cloud_firestore.dart';

class HandymanService {
  Future<void> updateUserProfile({
    required String handyManId,
    required String handyManName,
    required String handyManPhone,
    required String handyManJobTitle,
    required String handyManImageUrl,
    required String handyManAddress,
  }) async {
    try {
      final userDocRef =
          FirebaseFirestore.instance.collection("handymen").doc(handyManId);

      // Generate address keywords for partial matching
      final addressKeywords = handyManAddress
          .toLowerCase()
          .split(RegExp(r'[\s,/]+')); // Split into keywords

      // Update user document in Firestore with the new profile data
      await userDocRef.update({
        "handyManName": handyManName,
        "handyManPhone": handyManPhone,
        "handyManJobTitle": handyManJobTitle,
        "handyManImageUrl": handyManImageUrl,
        "handyManAddress": handyManAddress,
        "addressKeywords": addressKeywords, // Save keywords for search
        "updatedAt": Timestamp.fromDate(DateTime.now()), // Update timestamp
      });
    } catch (e) {
      throw Exception('Error updating profile: $e');
    }
  }
}
