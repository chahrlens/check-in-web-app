import 'package:flutter/material.dart';

class FixedContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final double minWidth;
  final double maxHeight;
  final double minHeight;

  const FixedContainer({
    super.key,
    required this.child,
    required this.maxWidth,
    required this.minWidth,
    this.maxHeight = double.infinity,
    this.minHeight = 0,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        minWidth: minWidth,
        maxHeight: maxHeight,
        minHeight: minHeight,
      ),
      child: child,
    );
  }
}
