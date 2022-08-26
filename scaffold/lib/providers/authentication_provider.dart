import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scaffold/services/services.dart';

final authenticationProvider =
    StateNotifierProvider<AuthenticationProvider, User?>(
  (ref) => AuthenticationProvider(ref.read),
);

class AuthenticationProvider extends StateNotifier<User?> {
  final Reader _read;

  StreamSubscription<User?>? _authStateChangesSubscription;

  AuthenticationProvider(this._read) : super(null) {
    _authStateChangesSubscription?.cancel();
    _authStateChangesSubscription = _read(authenticationRepositoryProvider)
        .authStateChanges
        .listen((user) => state = user);
  }

  @override
  void dispose() {
    _authStateChangesSubscription?.cancel();
    super.dispose();
  }

  User? getCurrentUser() {
    return _read(authenticationRepositoryProvider).getCurrentUser();
  }

  Future<void> signOut() async {
    await _read(authenticationRepositoryProvider).signOut();
  }

  Future<User?> signIn(String email, String password) async {
    return await _read(authenticationRepositoryProvider)
        .signIn(email, password);
  }

  Future<User?> signUp(String email, String password) async {
    return await _read(authenticationRepositoryProvider)
        .signUp(email, password);
  }
}
