import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scaffold/providers/providers.dart';
import 'package:scaffold/ui/pages/pages.dart';

class AppLoading extends ConsumerWidget {
  const AppLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.read(appLoadingProvider);

    final isUserLoggedIn = userState != null;

    if (isUserLoggedIn) {
      return const LoggedInAware();
    }

    return const SignInPage();
  }
}

class LoggedInAware extends ConsumerStatefulWidget {
  const LoggedInAware({Key? key}) : super(key: key);

  @override
  LoggedInAwareState createState() => LoggedInAwareState();
}

class LoggedInAwareState extends ConsumerState<LoggedInAware> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _evaluateUserCondition();
    });
  }
  
  void _evaluateUserCondition() async {
    Navigator.popAndPushNamed(
      context,
      'home',
    );
    return;
  }


  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
