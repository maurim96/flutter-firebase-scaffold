import 'package:flutter/material.dart';
import 'package:scaffold/app/app_loading.dart';

class Routing {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'app_loading':
        return MaterialPageRoute(builder: (_) => const AppLoading());
      default:
        return MaterialPageRoute(builder: (_) => const AppLoading());
    }
  }
}
