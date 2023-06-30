import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/providers.dart';
import 'package:app/ui/theme/custom_colors.dart';
import 'package:app/ui/widgets/widgets.dart';
import 'package:app/utils/utils.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  String errorMsg = '';
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();

  _setLoading() {
    setState(() => loading = true);
    setState(() => errorMsg = "");
  }

  signUpWithEmailAndPassword() async {
    if (formKey.currentState!.validate()) {
      _setLoading();
      final navigator = Navigator.of(context);
      final result = await ref.read(authenticationProvider.notifier).signUp(
            name: nameController.text,
            email: emailController.text,
            password: passwordController.text,
          );

      result.when(
        data: (value) {
          setState(() => loading = false);
          navigator.popAndPushNamed("home");
        },
        error: (error, stackTrace) {
          setState(() => loading = false);
          setState(() => errorMsg = error.toString());
        },
        loading: () => {},
      );
    }
  }

  signUpWithGoogle() async {
    _setLoading();
    final navigator = Navigator.of(context);
    final result =
        await ref.read(authenticationProvider.notifier).signInWithGoogle();

    result.when(
      data: (value) {
        setState(() => loading = false);
        navigator.popAndPushNamed("home");
      },
      error: (error, stackTrace) {
        setState(() => loading = false);
        setState(() => errorMsg = error.toString());
      },
      loading: () => {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomCircularLoader(
      opacity: .2,
      isLoading: loading,
      child: Scaffold(
        backgroundColor: primary500,
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: primary500,
          title: const Text("Sign up"),
          toolbarHeight: 70,
          titleTextStyle: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
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
                child: Column(
                  children: [
                    Form(
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
                          errorMsg.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(errorMsg,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(color: error)),
                                  ),
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(
                            height: 25,
                          ),
                          PrimaryButton(
                            title: "Sign Up",
                            minimumSize: MaterialStateProperty.all(
                              const Size.fromHeight(45),
                            ),
                            onPressed: () => signUpWithEmailAndPassword(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const OrDividerWidget(),
                    const SizedBox(
                      height: 15,
                    ),
                    GoogleSignInButton(
                      onPressed: () => signUpWithGoogle(),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    AppleSignInButton(
                      onPressed: () => {},
                    ),
                    const Expanded(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    const Divider(
                      height: 30,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                              text: "Already have an account? ",
                              style: Theme.of(context).textTheme.bodyMedium),
                          TextSpan(
                            text: "Sign In",
                            style: (Theme.of(context).textTheme.bodyMedium
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
          ],
        ),
      ),
    );
  }
}
