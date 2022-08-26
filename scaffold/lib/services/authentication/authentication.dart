import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scaffold/domain/ports/outbound/authentication_repo.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authenticationRepositoryProvider =
    Provider<FirebaseAuthentication>((ref) => FirebaseAuthentication(ref.read));

class FirebaseAuthentication implements AuthenticationRepo {
  final Reader _read;

  const FirebaseAuthentication(this._read);

  @override
  Stream<User?> get authStateChanges =>
      _read(firebaseAuthProvider).authStateChanges();

  @override
  User? getCurrentUser() {
    try {
      return _read(firebaseAuthProvider).currentUser;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() {
    try {
      return _read(firebaseAuthProvider).signOut();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email, password: password);

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(email: email, password: password);

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }
}
