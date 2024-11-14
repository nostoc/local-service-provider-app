import "package:cloud_firestore/cloud_firestore.dart";

class HandyManModel {
  final String handyManId;
  final String handyManName;
  final String handyManEmail;
  final String handyManPhone;
  final String handyManJobTitle;
  final String handyManImageUrl;
  final String handyManAddress;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String password;

  HandyManModel(
      {required this.handyManId,
      required this.handyManName,
      required this.handyManEmail,
      required this.handyManPhone,
      required this.handyManJobTitle,
      required this.handyManImageUrl,
      required this.handyManAddress,
      required this.createdAt,
      required this.updatedAt,
      required this.password});

  // convert a User instance to a map (to save in firestore)
  Map<String, dynamic> toJson() {
    return {
      "handyManId": handyManId,
      "handyManName": handyManName,
      "handyManEmail": handyManEmail,
      "handyManPhone": handyManPhone,
      "handyManJobTitle": handyManJobTitle,
      "handyManImageUrl": handyManImageUrl,
      "handyManAddress": handyManAddress,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
      "password": password,
    };
  }

  // convert a map to a User instance (to read from firestore)
  factory HandyManModel.fromJson(Map<String, dynamic> json) {
    return HandyManModel(
      handyManId: json["handyManId"] ?? "",
      handyManName: json["handyManName"] ?? "",
      handyManEmail: json["handyManEmail"] ?? "",
      handyManPhone: json["handyManPhone"] ?? "",
      handyManJobTitle: json["handyManJobTitle"] ?? "",
      handyManImageUrl: json["handyManImageUrl"] ?? "",
      handyManAddress: json["handyManAddress"] ?? "",
      createdAt: (json["createdAt"] as Timestamp).toDate(),
      updatedAt: (json["updatedAt"] as Timestamp).toDate(),
      password: json["password"] ?? "",
    );
  }
}
