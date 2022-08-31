import 'package:flutter/material.dart';
import 'package:scaffold/core/app_loading.dart';
import 'package:scaffold/ui/theme/theme.dart';
import 'package:scaffold/routing.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldKey =
    GlobalKey<ScaffoldMessengerState>();

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      title: 'Scaffold',
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldKey,
      home: const AppLoading(),
      onGenerateRoute: Routing.generateRoute,
    );
  }
}
