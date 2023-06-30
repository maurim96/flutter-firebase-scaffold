import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:app/utils/utils.dart';

class GoogleSignInButton extends StatelessWidget {
  final Function() onPressed;

  const GoogleSignInButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.resolveWith(
          (states) => EdgeInsets.only(
              top: 15, bottom: 15, left: displayWidth(context) / 4.5),
        ),
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
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SvgPicture.asset(
            Assets.googleLogoSvg,
            height: 20,
            width: 20,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            "Continue with Google",
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ],
      ),
    );
  }
}
