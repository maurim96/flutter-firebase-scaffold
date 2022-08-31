import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class AuthenticationRepo {
  Stream<User?> get authStateChanges;
  AsyncValue<User?> getCurrentUser();
  Future<AsyncValue<User?>> signUp(String email, String password);
  Future<AsyncValue<User?>> signIn(String email, String password);
  Future<AsyncValue<User?>> signInWithGoogle();
  Future<AsyncValue<User?>> signInWithApple();
  Future<AsyncValue<void>> signOut();
}
