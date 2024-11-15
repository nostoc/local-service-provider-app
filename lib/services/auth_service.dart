import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_service_provider_app/services/exceptions/auth_exceptions.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> signUpUser(
      {required String email, required String password}) async {
    try {
      //create the user in firebase auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add the user to firestore with minimal initial data

      final user = userCredential.user;
      if (user != null) {
        //print('User created successfully: ${user.uid}');
        final userData = {
          "handyManId": user.uid,
          "handyManEmail": email,
          "createdAt": Timestamp.fromDate(DateTime.now()),
          "updatedAt": Timestamp.fromDate(DateTime.now()),
          // Other fields will be filled in later, set empty for now
          "handyManName": "",
          "handyManPhone": "",
          "handyManJobTitle": "",
          "handyManImageUrl": "",
          "handyManAddress": "",
          "password": "",
        };

        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .set(userData);
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

  //sign out
  // Sign out
  //This methode will sign out the user and print a message to the console
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      //print('Signed out');
    } on FirebaseAuthException catch (e) {
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }
}
