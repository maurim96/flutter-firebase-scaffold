import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scaffold/providers/providers.dart';

final appLoadingProvider = Provider<User?>((ref) {
  final user = ref.read(authenticationProvider);
  return user;
});
