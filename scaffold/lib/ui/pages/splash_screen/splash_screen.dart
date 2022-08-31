import 'package:flutter/material.dart';
import 'package:scaffold/ui/widgets/widgets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CustomCircularLoader(
        isLoading: true,
        child: SizedBox.shrink(),
      ),
    );
  }
}
