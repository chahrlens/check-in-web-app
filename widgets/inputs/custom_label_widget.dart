import 'package:qr_check_in/shared/resources/custom_style.dart';
import 'package:qr_check_in/shared/resources/dimensions.dart';
import 'package:flutter/material.dart';

class CustomLabelWidget extends StatelessWidget {
  final String title;
  final String label;
  final IconData prefixIcon;
  final TextEditingController controller;

  CustomLabelWidget({
    super.key,
    required this.title,
    required this.label,
    required this.prefixIcon,
  })  : controller = TextEditingController(text: label);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(color: colorScheme.onPrimary),
        ),
        const SizedBox(
          height: Dimensions.heightSize *
              0.5, // You should replace this with the actual value
        ),
        TextField(
          readOnly: true,
          controller: controller,
          style: CustomStyle.textStyleBlack(
              context), // Make sure to define CustomStyle.textStyleWhite
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            labelStyle: CustomStyle.textStyleBlack(context),
            filled: true,
            fillColor: colorScheme.onTertiaryContainer,
            hintStyle: CustomStyle.textStyleBlack(context),
            focusedBorder: CustomStyle.focusBorder(context),
            enabledBorder: CustomStyle.focusErrorBorder(context),
            errorBorder: CustomStyle.focusErrorBorder(context),
            prefixIcon: Icon(prefixIcon),
          ),
        ),
        const SizedBox(
          height: Dimensions.heightSize,
        ),
      ],
    );
  }
}
