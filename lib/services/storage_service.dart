import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class HandymanStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImage({
    required File imageFile,
    required String handymanId,
  }) async {
    try {
      final storageRef =
          _storage.ref().child('handyman_images/$handymanId.jpg');
      final uploadTask = await storageRef.putFile(imageFile);
      final imageUrl = await uploadTask.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
