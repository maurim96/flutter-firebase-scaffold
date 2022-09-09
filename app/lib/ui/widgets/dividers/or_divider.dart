import 'package:flutter/material.dart';
import 'package:app/ui/theme/custom_colors.dart';

class OrDividerWidget extends StatelessWidget {
  const OrDividerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(
            color: complementary300,
            endIndent: 30,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 3),
          child: Text(
            "or",
            style: Theme.of(context)
                .textTheme
                .bodyText2
                ?.copyWith(color: placeholder),
          ),
        ),
        const Expanded(
          child: Divider(
            color: complementary300,
            indent: 30,
          ),
        ),
      ],
    );
  }
}
