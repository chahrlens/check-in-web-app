import 'package:flutter/material.dart';

class ToolTipButton extends StatelessWidget {
  final String tooltipMessage;
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final Color bgColor;

  const ToolTipButton({
    super.key,
    required this.tooltipMessage,
    required this.label,
    required this.icon,
    required this.onPressed,
    this.bgColor = Colors.green,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltipMessage,
      child: ElevatedButton.icon(
        style: ButtonStyle(
          iconColor: const WidgetStatePropertyAll<Color>(Colors.white),
          backgroundColor: WidgetStatePropertyAll<Color>(bgColor),
          surfaceTintColor: const WidgetStatePropertyAll<Color>(Colors.white),
          textStyle: const WidgetStatePropertyAll<TextStyle>(
            TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        icon: Icon(icon),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        onPressed: onPressed,
      ),
    );
  }
}
