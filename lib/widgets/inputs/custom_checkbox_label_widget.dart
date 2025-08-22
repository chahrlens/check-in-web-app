import 'custom_checkbox_widget.dart';
import 'package:flutter/material.dart';

class CustomCheckboxLabelWidget extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?>? onChanged;
  final String label;
  final IconData? icon;
  const CustomCheckboxLabelWidget(
      {super.key,
      required this.isChecked,
      required this.onChanged,
      required this.label,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment
          .start, // Para alinear el texto arriba si se expande
      children: [
        CustomCheckbox(
          value: isChecked,
          onChanged: onChanged,
          activeColor: Theme.of(context).colorScheme.primary,
          unSelectedColor: Theme.of(context).colorScheme.surface,
          checkColor: Theme.of(context).colorScheme.onSurface,
        ),
        const SizedBox(width: 10),
        icon != null ? Icon(icon) : const Icon(Icons.security),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            label,
            softWrap: true,
            overflow: TextOverflow.visible,
          ),
        ),
      ],
    );
  }
}
