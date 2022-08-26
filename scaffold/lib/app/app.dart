import 'package:flutter/material.dart';
import 'package:scaffold/app/app_loading.dart';
import 'package:scaffold/routing.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
      title: 'Footprint',
      navigatorKey: navigatorKey,
      home: const AppLoading(),
      onGenerateRoute: Routing.generateRoute,
    );
  }
}
