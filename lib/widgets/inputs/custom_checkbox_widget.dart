import 'package:flutter/material.dart';
import 'package:qr_check_in/shared/resources/custom_style.dart';

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final void Function(bool?)? onChanged;
  final Color activeColor;
  final Color unSelectedColor;
  final Color checkColor;
  final String text;
  final bool isEnabled;

  const CustomCheckbox(
      {super.key,
      required this.value,
      required this.onChanged,
      required this.activeColor,
      required this.unSelectedColor,
      required this.checkColor,
      this.text = "",
      this.isEnabled = true});

  @override
  CustomCheckboxState createState() => CustomCheckboxState();
}

class CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    // adding textbox in the right side of the checkbox
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 30,
            height: 30,
            child: Checkbox(
              value:  widget.value,
              onChanged: widget.isEnabled ? widget.onChanged : null,
              activeColor: widget.activeColor,
              checkColor: widget.checkColor,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            widget.text,
            style: CustomStyle.defaultStyle(context),
          ),
        ],
      ),
    );
  }
}
