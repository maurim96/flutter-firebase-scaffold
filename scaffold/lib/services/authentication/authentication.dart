import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scaffold/domain/ports/outbound/authentication_repo.dart';
import 'package:scaffold/firebase_options.dart';
import 'package:scaffold/utils/utils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(
              clientId: DefaultFirebaseOptions.currentPlatform.iosClientId)
          .signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  // TODO: to be implemented
  @override
  Future<User?> signInWithApple() async {
    try {
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);

      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        rawNonce: rawNonce,
      );

      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(oauthCredential);

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
