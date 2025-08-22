import "package:flutter/material.dart";
import "package:qr_check_in/shared/resources/dimensions.dart";

class CustomButton extends StatelessWidget {
  final Color color;
  final Widget text;
  final bool isLoading;
  final VoidCallback onPress;
  final double? width;
  final double? height;
  const CustomButton(
      {super.key,
      required this.color,
      required this.text,
      required this.isLoading,
      required this.onPress,
      this.width = 16,
      this.height = 16});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(vertical: height ?? 16, horizontal: width ?? 16),
        ),
        onPressed: isLoading ? null : onPress,
        child: isLoading
            ? SizedBox(
                height: Dimensions.largeTextSize,
                width: Dimensions.largeTextSize,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: colorScheme.surface),
              )
            : text);
  }
}
