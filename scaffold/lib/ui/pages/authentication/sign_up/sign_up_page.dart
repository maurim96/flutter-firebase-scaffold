import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scaffold/providers/providers.dart';
import 'package:scaffold/ui/theme/custom_colors.dart';
import 'package:scaffold/ui/widgets/widgets.dart';
import 'package:scaffold/utils/utils.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  signUpWithEmailAndPassword() async {
    if (formKey.currentState!.validate()) {
      setState(() => loading = true);
      final navigator = Navigator.of(context);
      final result =
          await ref.read(authenticationProvider.notifier).signUp(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
          );

      setState(() => loading = false);
      if (result != null) {
        navigator.popAndPushNamed("home");
      }
    }
  }

  signUpWithGoogle() async {
    setState(() => loading = true);
    final navigator = Navigator.of(context);
    final result =
        await ref.read(authenticationProvider.notifier).signInWithGoogle();

    setState(() => loading = false);
    if (result != null) {
      navigator.popAndPushNamed("home");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomCircularLoader(
      opacity: .2,
      isLoading: loading,
      child: Scaffold(
        backgroundColor: primary500,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: displayHeight(context) / 7, left: 20, bottom: 10),
              child: Text(
                "Create Account",
                style: Theme.of(context).textTheme.headline4?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      RegularTextFieldWidget(
                        label: "Full Name",
                        textCapitalization: TextCapitalization.words,
                        textEditingController: nameController,
                        textInputType: TextInputType.name,
                        validator: (value) => Utils.isEmpty(value),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RegularTextFieldWidget(
                        label: "Email",
                        textCapitalization: TextCapitalization.none,
                        textEditingController: emailController,
                        textInputType: TextInputType.emailAddress,
                        validator: (value) => Utils.isEmailValid(value),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      PasswordTextFieldWidget(
                        label: "Password",
                        textEditingController: passwordController,
                        validator: (password) =>
                            Utils.isValidPassword(password),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      PrimaryButton(
                        title: "Sign Up",
                        minimumSize: MaterialStateProperty.all(
                          const Size.fromHeight(45),
                        ),
                        onPressed: () => signUpWithEmailAndPassword(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text("or",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2
                              ?.copyWith(color: placeholder)),
                      const SizedBox(
                        height: 10,
                      ),
                      GoogleSignInButton(
                        onPressed: () => signUpWithGoogle(),
                        minimumSize: MaterialStateProperty.all(
                          const Size.fromHeight(45),
                        ),
                      ),
                      const Expanded(
                        child: SizedBox.shrink(),
                      ),
                      const Divider(
                        height: 30,
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: "Already have an account? ",
                                style: Theme.of(context).textTheme.bodyText2),
                            TextSpan(
                              text: "Sign In",
                              style: (Theme.of(context).textTheme.bodyText2
                                      as TextStyle)
                                  .copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pushReplacementNamed(
                                      context,
                                      'sign_in',
                                    ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
