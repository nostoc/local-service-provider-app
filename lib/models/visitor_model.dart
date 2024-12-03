import "package:cloud_firestore/cloud_firestore.dart";

class VisitorModel {
  final String visitorId;
  final String visitorEmail;
  final String hashedPassword;
  final DateTime createdAt;
  final DateTime updatedAt;

  VisitorModel({
    required this.visitorId,
    required this.visitorEmail,
    required this.hashedPassword,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert a Visitor instance to a map (to save in Firestore)
  Map<String, dynamic> toJson() {
    return {
      "visitorId": visitorId,
      "visitorEmail": visitorEmail,
      "hashedPassword": hashedPassword,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }

  // Convert a map to a Visitor instance (to read from Firestore)
  factory VisitorModel.fromJson(Map<String, dynamic> json) {
    return VisitorModel(
      visitorId: json["visitorId"] ?? "",
      visitorEmail: json["visitorEmail"] ?? "",
      hashedPassword: json["hashedPassword"] ?? "",
      createdAt: (json["createdAt"] as Timestamp).toDate(),
      updatedAt: (json["updatedAt"] as Timestamp).toDate(),
    );
  }
}
