import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_service_provider_app/exceptions/auth_exceptions.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<void> signUpVisitor(
      {required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      //print('Error creating user: ${mapFirebaseAuthExceptionCode(e.code)}');
      throw Exception(mapFirebaseAuthExceptionCode(e.code));
    } catch (e) {
      // print('Error creating user: $e');
    }
  }

 Future<void> signInVisitor(
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
}
