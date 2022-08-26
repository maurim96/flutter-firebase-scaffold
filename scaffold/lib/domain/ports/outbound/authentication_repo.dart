import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationRepo {
  Stream<User?> get authStateChanges;
  User? getCurrentUser();
  Future<User?> signUp(String email, String password);
  Future<User?> signIn(String email, String password);
  Future<void> signOut();
}
