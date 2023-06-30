# :construction: :construction_worker: Flutterfire Scaffold - Under construction... :construction_worker_woman: :construction:

## Description
Flutterfire scaffold project intended to minimize the initial time setup of any Flutter + Firebase + Riverpod project. Includes basic features, setup configurations, flutter flavors for environments management, authentication, state management initialization, routing and a couple of standard screens

<div align="center">
  <a href="https://firebase.flutter.dev/docs/overview/">
    <img width="500" height="140px" src="https://user-images.githubusercontent.com/22548752/186985350-2c9af743-aa82-47b5-b373-94e72a62c560.jpg" alt="Flutter + Firebase + Riverpod logo"><br/>
  </a>
  <h1 align="center">Flutterfire + Riverpod</h1>
</div>

## Prerequisites
- [x] Flutter SDK (3.10.5) - https://docs.flutter.dev/development/tools/sdk/releases
- [x] Flutterfire CLI (0.2.7) - https://firebase.flutter.dev/docs/overview
- [x] Android Studio (2021.1) - https://developer.android.com/studio
- [x] Android SDK (33.0.0)
- [x] Xcode (14.3.1) - https://developer.apple.com/xcode/
- [x] VS Code (1.79.2) or similar IDE - https://code.visualstudio.com/
- [x] CocoaPods (1.12.1) - https://cocoapods.org/

## Prerequisites Steps
- Setup two Firebase Projects (Dev & Prod) - https://console.firebase.google.com/
- Enable Authentication: Email and Password, Google and Apple providers
- Enable Firestore Collection from Firebase console. Basic rule you can implement:

  ```
    rules_version = '2';
    service cloud.firestore {
      match /databases/{database}/documents {
      function isLoggedIn() {
          return request.auth != null;
        }
        
        match /{document=**} {
          allow read, write: if isLoggedIn();
        }
      }
    }
    ```
- Run `flutterfire configure` for each of them (it will generate 3 files per environment):
  - Rename and replace `firebase_options_dev.dart` and `firebase_options_prod.dart` inside `app/lib`
  - Replace `google-services.json` inside `app/android/app/src/dev` and `app/android/app/src/prod`
  - Replace `firebase_app_id_file.json` inside `app/ios/Runner/Firebase/Dev` and `app/ios/Runner/Firebase/Dev` 
    - **Important: drag and drop the files from XCode, otherwise it won't work**

## Useful Commands
- Build injection dependencies
  - ##### `dart run build_runner build --delete-conflicting-outputs`
- Run app in debug mode - dev
  - ##### `flutter run --flavor dev`
- Build app in release mode for ios - dev
  - ##### `flutter build ios --release --flavor dev`
- Build app in release mode for android - dev
  - ##### `flutter build apk --release --flavor dev`
- Run app in debug mode - prod
  - ##### `flutter run --flavor prod`
- Build app in release mode for ios - prod
  - ##### `flutter build ios --release --flavor prod`
- Build app in release mode for android - prod
  - ##### `flutter build apk --release --flavor prod`

#

## Architecture
### Clean Architecture + Repository Pattern
![Structure Example](https://miro.medium.com/max/1400/1*xxr1Idc8UoNELOzqXcJnag.png)

#### Packages
##### -> Injectable - https://pub.dev/packages/injectable
##### -> Injectable Generator - https://pub.dev/packages/injectable_generator
##### -> Get It - https://pub.dev/packages/get_it

## Features & Libraries

### State Management
#### Riverpod
##### -> Riverpod (2.3.6) - https://pub.dev/packages/flutter_riverpod

### Firebase Features

#### Authentication
##### -> Email & Password (4.6.3) - https://pub.dev/packages/firebase_auth
##### -> Google Provider (6.1.4) - https://pub.dev/packages/google_sign_in
##### -> Apple Provider (5.0.0) - https://pub.dev/packages/sign_in_with_apple + https://pub.dev/packages/crypto

#### Persistance
##### -> Firestore Collection (4.8.2) - https://pub.dev/packages/cloud_firestore

#### Push Notifications
##### -> Firebase Messaging (14.6.4) - https://pub.dev/packages/firebase_messaging
