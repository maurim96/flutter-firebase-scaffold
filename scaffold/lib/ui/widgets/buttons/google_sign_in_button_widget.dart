import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scaffold/utils/utils.dart';

class GoogleSignInButton extends StatelessWidget {
  final Function() onPressed;
  final MaterialStateProperty<Size?>? minimumSize;

  const GoogleSignInButton({
    Key? key,
    required this.onPressed,
    this.minimumSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.resolveWith((states) =>
            const EdgeInsets.only(top: 12, bottom: 12, left: 24, right: 24)),
        minimumSize: minimumSize,
        elevation: MaterialStateProperty.resolveWith((states) => 0),
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return const Color(0xFFD6D6D6);
            }
            return Colors.black;
          },
        ),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) {
            if (states.contains(MaterialState.disabled)) {
              return const Color(0xFFE6E6E6);
            }
            return Colors.white;
          },
        ),
        shape: MaterialStateProperty.resolveWith(
          (_) => const RoundedRectangleBorder(
            side: BorderSide(color: Color.fromARGB(50, 0, 0, 0)),
            borderRadius: BorderRadius.all(
              Radius.circular(100),
            ),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.googleLogoSvg,
            height: 20,
            width: 20,
          ),
          const SizedBox(
            width: 10,
          ),
          const Text(
            "CONTINUE WITH GOOGLE",
          ),
        ],
      ),
    );
  }
}
