import "package:cloud_firestore/cloud_firestore.dart";

class HandyManModel {
  final String handyManId;
  final String handyManName;
  final String handyManEmail;
  final String handyManPhone;
  final String handyManJobTitle;
  final String handyManImageUrl;
  final String handyManAddress;
  final List<String> addressKeywords; // Added for partial matching
  final DateTime createdAt;
  final DateTime updatedAt;
  final String password;

  HandyManModel({
    required this.handyManId,
    required this.handyManName,
    required this.handyManEmail,
    required this.handyManPhone,
    required this.handyManJobTitle,
    required this.handyManImageUrl,
    required this.handyManAddress,
    required this.addressKeywords, // Initialize this
    required this.createdAt,
    required this.updatedAt,
    required this.password,
  });

  // Convert a User instance to a map (to save in Firestore)
  Map<String, dynamic> toJson() {
    return {
      "handyManId": handyManId,
      "handyManName": handyManName,
      "handyManEmail": handyManEmail,
      "handyManPhone": handyManPhone,
      "handyManJobTitle": handyManJobTitle,
      "handyManImageUrl": handyManImageUrl,
      "handyManAddress": handyManAddress,
      "addressKeywords": addressKeywords, // Save address keywords
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "password": password,
    };
  }

  // Convert a map to a User instance (to read from Firestore)
  factory HandyManModel.fromJson(Map<String, dynamic> json) {
    return HandyManModel(
      handyManId: json["handyManId"] ?? "",
      handyManName: json["handyManName"] ?? "",
      handyManEmail: json["handyManEmail"] ?? "",
      handyManPhone: json["handyManPhone"] ?? "",
      handyManJobTitle: json["handyManJobTitle"] ?? "",
      handyManImageUrl: json["handyManImageUrl"] ?? "",
      handyManAddress: json["handyManAddress"] ?? "",
      addressKeywords:
          List<String>.from(json["addressKeywords"] ?? []), // Parse keywords
      createdAt: (json["createdAt"] as Timestamp).toDate(),
      updatedAt: (json["updatedAt"] as Timestamp).toDate(),
      password: json["password"] ?? "",
    );
  }
}
