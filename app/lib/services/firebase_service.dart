import 'package:firebase_core/firebase_core.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:app/firebase_options_dev.dart';
import 'package:app/firebase_options_prod.dart';

class FirebaseService {
  static Future<FirebaseService> init() async {
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

    await Firebase.initializeApp(
      options: isDev
          ? DevFirebaseOptions.currentPlatform
          : ProdFirebaseOptions.currentPlatform,
    );
    return FirebaseService();
  }
}
