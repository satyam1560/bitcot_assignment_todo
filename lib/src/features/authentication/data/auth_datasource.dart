import 'package:firebase_auth/firebase_auth.dart';

class AuthDatasource {
  AuthDatasource({required this.firebaseAuth});
  final FirebaseAuth firebaseAuth;
  Future<User?> createUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (error) {
      rethrow;
    }
  }

  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signout() async {
    try {
      await firebaseAuth.signOut();
    } catch (error) {
      rethrow;
    }
  }

  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }
}
