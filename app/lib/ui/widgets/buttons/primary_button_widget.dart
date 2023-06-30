import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final MaterialStateProperty<Size?>? minimumSize;

  const PrimaryButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.minimumSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.resolveWith((states) =>
            const EdgeInsets.only(top: 15, bottom: 15, left: 24, right: 24)),
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
            return const Color(0xFF01699D);
          },
        ),
        shape: MaterialStateProperty.resolveWith(
          (_) => const RoundedRectangleBorder(
            side: BorderSide(color: Color.fromARGB(15, 0, 0, 0)),
            borderRadius: BorderRadius.all(Radius.circular(100)),
          ),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        title,
        style:
            Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: Colors.white),
      ),
    );
  }
}
