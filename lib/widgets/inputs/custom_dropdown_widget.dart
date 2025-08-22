import 'package:flutter/material.dart';
import 'package:qr_check_in/shared/resources/custom_style.dart';
import 'package:qr_check_in/shared/resources/dimensions.dart';

class CustomDropdownWidget<T> extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String selectedValue;
  final List<DropdownMenuItem<String>> items;
  final String? Function(String?)? validator;
  final IconData prefixIcon;
  final ValueChanged<String?> onValueChanged;

  // final T selectedValue;

  const CustomDropdownWidget({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.selectedValue,
    required this.items,
    required this.validator,
    this.prefixIcon = Icons.person,
    // required this.selectedValue,
    required this.onValueChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: const TextStyle(color: Colors.black),
        ),
        const SizedBox(
          height: Dimensions.heightSize * 0.5,
        ),
        DropdownButtonFormField<String>(
          style: CustomStyle.textStyleWhite(context),
          onChanged: (value) {
            onValueChanged(value);
          },
          value: selectedValue,
          items: items,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            labelStyle: CustomStyle.textStyleWhite(context),
            filled: true,
            fillColor: colorScheme.primary,
            hintStyle: CustomStyle.textStyleWhite(context),
            focusedBorder: CustomStyle.focusBorder(context),
            enabledBorder: CustomStyle.focusErrorBorder(context),
            focusedErrorBorder: CustomStyle.focusErrorBorder(context),
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
