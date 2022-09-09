import 'package:flutter/material.dart';
import 'package:app/core/app_loading.dart';
import 'package:app/ui/pages/pages.dart';

class Routing {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'app_loading':
        return MaterialPageRoute(builder: (_) => const AppLoading());
      case 'home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case 'sign_in':
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case 'sign_up':
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      default:
        return MaterialPageRoute(builder: (_) => const AppLoading());
    }
  }
}
