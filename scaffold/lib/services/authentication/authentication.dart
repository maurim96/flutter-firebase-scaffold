import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:scaffold/core/error_handling/exceptions_mapper.dart';
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
  AsyncValue<User?> getCurrentUser() {
    try {
      return AsyncData(_read(firebaseAuthProvider).currentUser);
    } on FirebaseAuthException catch (e) {
      return AsyncError(Exception(getMessageFromFirebaseErrorCode(e.code)));
    } on Exception catch (e) {
      return AsyncError(Exception(getMessageFromException(e)));
    }
  }

  @override
  Future<AsyncValue<void>> signOut() async {
    try {
      await _read(firebaseAuthProvider).signOut();
      return const AsyncValue.data(null);
    } on FirebaseAuthException catch (e) {
      return AsyncError(Exception(getMessageFromFirebaseErrorCode(e.code)));
    } on Exception catch (e) {
      return AsyncError(Exception(getMessageFromException(e)));
    }
  }

  @override
  Future<AsyncValue<User?>> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email, password: password);

      return AsyncValue.data(userCredential.user);
    } on FirebaseAuthException catch (e) {
      return AsyncError(Exception(getMessageFromFirebaseErrorCode(e.code)));
    } on Exception catch (e) {
      return AsyncError(Exception(getMessageFromException(e)));
    }
  }

  @override
  Future<AsyncValue<User?>> signInWithGoogle() async {
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

      return AsyncValue.data(userCredential.user);
    } on FirebaseAuthException catch (e) {
      return AsyncValue.error(e);
    }
  }

  // TODO: to be implemented
  @override
  Future<AsyncValue<User?>> signInWithApple() async {
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

      return AsyncValue.data(userCredential.user);
    } on FirebaseAuthException catch (e) {
      return AsyncError(Exception(getMessageFromFirebaseErrorCode(e.code)));
    } on Exception catch (e) {
      return AsyncError(Exception(getMessageFromException(e)));
    }
  }

  @override
  Future<AsyncValue<User?>> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(email: email, password: password);

      return AsyncValue.data(userCredential.user);
    } on FirebaseAuthException catch (e) {
      return AsyncError(Exception(getMessageFromFirebaseErrorCode(e.code)));
    } on Exception catch (e) {
      return AsyncError(Exception(getMessageFromException(e)));
    }
  }
}
