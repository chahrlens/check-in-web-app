import 'package:flutter/material.dart';

class StarRatingWidget extends StatelessWidget {
  final int rating; // valor actual de la calificación (1 a 5)
  final void Function(int) onRatingChanged;
  final double iconSize;
  final Color activeColor;
  final Color inactiveColor;

  const StarRatingWidget({
    super.key,
    required this.rating,
    required this.onRatingChanged,
    this.iconSize = 32,
    this.activeColor = Colors.amber,
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        return GestureDetector(
          onTap: () {
            onRatingChanged(starIndex);
          },
          child: Icon(
            starIndex <= rating ? Icons.star : Icons.star_border,
            color: starIndex <= rating ? activeColor : inactiveColor,
            size: iconSize,
          ),
        );
      }),
    );
  }
}
