import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:app/core/error_handling/exceptions_mapper.dart';
import 'package:app/domain/ports/outbound/authentication_repo.dart';
import 'package:app/firebase_options_dev.dart';
import 'package:app/firebase_options_prod.dart';
import 'package:app/utils/utils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

final firebaseAuthProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authenticationRepositoryProvider =
    Provider<FirebaseAuthentication>((ref) => FirebaseAuthentication(ref));

class FirebaseAuthentication implements AuthenticationRepo {
  final Ref _ref;

  const FirebaseAuthentication(this._ref);

  @override
  Stream<User?> get authStateChanges =>
      _ref.watch(firebaseAuthProvider).authStateChanges();

  @override
  AsyncValue<User?> getCurrentUser() {
    try {
      return AsyncData(_ref.read(firebaseAuthProvider).currentUser);
    } on FirebaseAuthException catch (e, stackTrace) {
      return AsyncError(
          Exception(getMessageFromFirebaseErrorCode(e.code)), stackTrace);
    } on Exception catch (e, stackTrace) {
      return AsyncError(Exception(getMessageFromException(e)), stackTrace);
    }
  }

  @override
  Future<AsyncValue<void>> signOut() async {
    try {
      await _ref.read(firebaseAuthProvider).signOut();
      return const AsyncValue.data(null);
    } on FirebaseAuthException catch (e, stackTrace) {
      return AsyncError(
          Exception(getMessageFromFirebaseErrorCode(e.code)), stackTrace);
    } on Exception catch (e, stackTrace) {
      return AsyncError(Exception(getMessageFromException(e)), stackTrace);
    }
  }

  @override
  Future<AsyncValue<User>> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _ref
          .read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email, password: password);

      if (userCredential.user == null) {
        return AsyncError(
            "Error while loging in into the app", StackTrace.current);
      }

      return AsyncValue.data(userCredential.user as User);
    } on FirebaseAuthException catch (e, stackTrace) {
      return AsyncError(
          Exception(getMessageFromFirebaseErrorCode(e.code)), stackTrace);
    } on Exception catch (e, stackTrace) {
      return AsyncError(Exception(getMessageFromException(e)), stackTrace);
    }
  }

  @override
  Future<AsyncValue<User>> signInWithGoogle() async {
    try {
      late final PackageInfo packageInfo;
      try {
        packageInfo = await PackageInfo.fromPlatform();
      } catch (exception) {
        /// Fallback value
        packageInfo = PackageInfo(
          appName: 'Dev - Scaffold',
          packageName: 'com.example.scaffold.dev',
          buildNumber: '0',
          version: '0.0.0',
        );
      }
      final isDev = packageInfo.packageName == 'com.example.scaffold.dev';

      final GoogleSignInAccount? googleUser = await GoogleSignIn(
              clientId: isDev
                  ? DevFirebaseOptions.currentPlatform.iosClientId
                  : ProdFirebaseOptions.currentPlatform.iosClientId)
          .signIn();

      if (googleUser == null) {
        return AsyncError("No google account provided.", StackTrace.current);
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final user =
          await FirebaseAuth.instance.signInWithCredential(credential).then(
        (userCredential) async {
          if (userCredential.user == null) {
            throw ("Error creating user");
          }

          final User user = userCredential.user!;

          final userRef = await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get();

          if (!userRef.exists) {
            final deviceToken = await FirebaseMessaging.instance.getToken();

            final newUser = {
              "email": user.email,
              "name": user.displayName ?? user.email?.split("@")[0],
              "deviceToken": deviceToken,
              "inAppNotification": true,
            };

            await FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .set(newUser);
          }

          return user;
        },
      );

      return AsyncValue.data(user);
    } on FirebaseAuthException catch (e, stackTrace) {
      return AsyncError(
          Exception(getMessageFromFirebaseErrorCode(e.code)), stackTrace);
    } on Exception catch (e, stackTrace) {
      return AsyncError(e, stackTrace);
    }
  }

  @override
  Future<AsyncValue<User>> signInWithApple() async {
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

      final user = await FirebaseAuth.instance
          .signInWithCredential(oauthCredential)
          .then(
        (userCredential) async {
          if (userCredential.user == null) {
            throw ("No Apple account provided");
          }

          final User user = userCredential.user!;

          final userRef = await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get();

          if (!userRef.exists) {
            final deviceToken = await FirebaseMessaging.instance.getToken();

            final newUser = {
              "email": user.email,
              "name": user.displayName ?? user.email?.split("@")[0],
              "deviceToken": deviceToken,
              "inAppNotification": true,
            };

            await FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .set(newUser);
          }

          return user;
        },
      );

      return AsyncValue.data(user);
    } on FirebaseAuthException catch (e, stackTrace) {
      return AsyncError(
          Exception(getMessageFromFirebaseErrorCode(e.code)), stackTrace);
    } on SignInWithAppleAuthorizationException catch (_) {
      return AsyncError("Error while loging in with Apple", StackTrace.current);
    } on Exception catch (e, stackTrace) {
      return AsyncError(Exception(getMessageFromException(e)), stackTrace);
    }
  }

  @override
  Future<AsyncValue<User>> signUp(String email, String password) async {
    try {
      User user = await _ref
          .read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (userCredential) async {
          if (userCredential.user == null) {
            throw ("Error creating user");
          }

          final User user = userCredential.user!;

          final userRef = await FirebaseFirestore.instance
              .collection("users")
              .doc(user.uid)
              .get();

          if (!userRef.exists) {
            final deviceToken = await FirebaseMessaging.instance.getToken();

            final newUser = {
              "email": email,
              "name": email.split("@")[0],
              "deviceToken": deviceToken,
              "inAppNotification": true,
            };

            await FirebaseFirestore.instance
                .collection("users")
                .doc(user.uid)
                .set(newUser);
          }

          return user;
        },
      );

      return AsyncValue.data(user);
    } on FirebaseAuthException catch (e, stackTrace) {
      return AsyncError(
          Exception(getMessageFromFirebaseErrorCode(e.code)), stackTrace);
    } on Exception catch (e, stackTrace) {
      return AsyncError(Exception(getMessageFromException(e)), stackTrace);
    }
  }
}
