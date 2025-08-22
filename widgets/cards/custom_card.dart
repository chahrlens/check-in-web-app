import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final Color color;

  const CustomCard({super.key, required this.onTap, required this.child, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
          color: color, // Blue background color
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: child),
    );
  }
}
