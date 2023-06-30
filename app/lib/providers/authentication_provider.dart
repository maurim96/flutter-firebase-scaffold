import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/services/services.dart';

final authenticationProvider =
    StateNotifierProvider<AuthenticationProvider, User?>(
  (ref) => AuthenticationProvider(ref),
);

class AuthenticationProvider extends StateNotifier<User?> {
  final Ref _ref;

  StreamSubscription<User?>? _authStateChangesSubscription;

  AuthenticationProvider(this._ref) : super(null) {
    _authStateChangesSubscription?.cancel();
    _authStateChangesSubscription = _ref
        .watch(authenticationRepositoryProvider)
        .authStateChanges
        .listen((user) => state = user);
  }

  @override
  void dispose() {
    _authStateChangesSubscription?.cancel();
    super.dispose();
  }

  AsyncValue<User?> getCurrentUser() {
    return _ref.read(authenticationRepositoryProvider).getCurrentUser();
  }

  Future<AsyncValue<void>> signOut() async {
    return await _ref.read(authenticationRepositoryProvider).signOut();
  }

  Future<AsyncValue<User?>> signIn(
      {required String email, required String password}) async {
    return await _ref
        .read(authenticationRepositoryProvider)
        .signIn(email, password);
  }

  Future<AsyncValue<User?>> signInWithGoogle() async {
    return await _ref.read(authenticationRepositoryProvider).signInWithGoogle();
  }

  Future<AsyncValue<User?>> signUp(
      {required String name,
      required String email,
      required String password}) async {
    return await _ref
        .read(authenticationRepositoryProvider)
        .signUp(email, password);
  }
}
