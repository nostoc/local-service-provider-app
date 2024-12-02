import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:local_service_provider_app/services/exceptions/auth_exceptions.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Hash password method
  String _hashPassword(String password) {
    // Using SHA-256 for password hashing
    final bytes = utf8.encode(password);
    final hashedPassword = sha256.convert(bytes);
    return hashedPassword.toString();
  }

  Future<void> signUpHandyMan(
      {required String email, required String password}) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        // Hash the password before storing
        final hashedPassword = _hashPassword(password);

        final userData = {
          "handyManId": user.uid,
          "handyManEmail": email,
          "hashedPassword": hashedPassword, // Store hashed password
          "createdAt": Timestamp.fromDate(DateTime.now()),
          "updatedAt": Timestamp.fromDate(DateTime.now()),
          "handyManName": "",
          "handyManPhone": "",
          "handyManJobTitle": "",
          "handyManImageUrl": "",
          "handyManAddress": "",
        };

        await _firestore.collection("handymen").doc(user.uid).set(userData);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> signUpVisitor(
      {required String email, required String password}) async {
    try {
      // Create user in Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user != null) {
        // Hash the password before storing
        final hashedPassword = _hashPassword(password);

        final userData = {
          "visitorId": user.uid,
          "visitorEmail": email,
          "hashedPassword": hashedPassword, // Store hashed password
          "createdAt": Timestamp.fromDate(DateTime.now()),
          "updatedAt": Timestamp.fromDate(DateTime.now()),
          
        };

        await _firestore.collection("visitors").doc(user.uid).set(userData);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }

  Future<void> signInUser(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = mapFirebaseAuthExceptionCode(e.code);
      throw Exception(errorMessage);
    } catch (error) {
      throw Exception('An unexpected error occurred: $error');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }
}
