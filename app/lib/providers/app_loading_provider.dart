import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/providers.dart';

final appLoadingProvider = Provider<AsyncValue<User?>>((ref) {
  return ref.read(authenticationProvider.notifier).getCurrentUser();
});
