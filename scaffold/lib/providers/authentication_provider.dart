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

  AsyncValue<User?> getCurrentUser() {
    return _read(authenticationRepositoryProvider).getCurrentUser();
  }

  Future<AsyncValue<void>> signOut() async {
    return await _read(authenticationRepositoryProvider).signOut();
  }

  Future<AsyncValue<User?>> signIn(
      {required String email, required String password}) async {
    return await _read(authenticationRepositoryProvider)
        .signIn(email, password);
  }

  Future<AsyncValue<User?>> signInWithGoogle() async {
    return await _read(authenticationRepositoryProvider).signInWithGoogle();
  }

  Future<AsyncValue<User?>> signUp(
      {required String name,
      required String email,
      required String password}) async {
    return await _read(authenticationRepositoryProvider)
        .signUp(email, password);
  }
}
