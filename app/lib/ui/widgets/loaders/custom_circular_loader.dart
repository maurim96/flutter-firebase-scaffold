import 'package:flutter/material.dart';
import 'package:app/ui/theme/custom_colors.dart';
import 'package:loading_overlay/loading_overlay.dart';

class CustomCircularLoader extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final double opacity;

  const CustomCircularLoader({
    Key? key,
    required this.isLoading,
    required this.child,
    this.opacity = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoadingOverlay(
      isLoading: isLoading,
      opacity: opacity,
      progressIndicator: const CircularProgressIndicator(
        backgroundColor: placeholderLight,
        color: primary300,
      ),
      color: primary700,
      child: child,
    );
  }
}
