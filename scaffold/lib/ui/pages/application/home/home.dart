import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scaffold/providers/providers.dart';
import 'package:scaffold/ui/widgets/widgets.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  signOut() async {
    final navigator = Navigator.of(context);

    final result = await ref.read(authenticationProvider.notifier).signOut();

    result.when(
      data: (_) => navigator.pushReplacementNamed("sign_in"),
      error: (error, stackTrace) => {},
      loading: () => setState((() => {})),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loggedInUser = ref.watch(authenticationProvider);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          loggedInUser != null
              ? Text(loggedInUser.uid)
              : const SizedBox.shrink(),
          loggedInUser != null
              ? Text(loggedInUser.email ?? "")
              : const SizedBox.shrink(),
          loggedInUser != null
              ? Text(loggedInUser.displayName ?? "")
              : const SizedBox.shrink(),
          PrimaryButton(
            title: "Sign Out",
            minimumSize: MaterialStateProperty.all(
              const Size.fromHeight(45),
            ),
            onPressed: () => signOut(),
          ),
        ],
      ),
    );
  }
}
