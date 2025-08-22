import 'package:qr_check_in/shared/resources/custom_style.dart';
import 'package:qr_check_in/shared/resources/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChange; // Optional onChange callback
  final VoidCallback? onTap; // Optional onChange callback
  final bool enabled;

  const CustomDatePicker(
      {super.key,
      required this.initialDate,
      this.firstDate,
      this.lastDate,
      required this.controller,
      required this.label,
      required this.hintText,
      required this.prefixIcon,
      this.keyboardType = TextInputType.text,
      this.validator,
      this.onChange,
      this.onTap,
      this.enabled = true});

  @override
  CustomDatePickerState createState() => CustomDatePickerState();
}

class CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _selectedDate;
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _selectedDate = widget.initialDate;
      widget.controller.text = formatDate(_selectedDate);
    });
  }

  void _handleDateChanged(DateTime newDate) {
    setState(() {
      _selectedDate = newDate;
    });
    widget.controller.text = formatDate(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        const SizedBox(
          height: Dimensions.heightSize * 0.5,
        ),
        TextFormField(
          onTap: () async {
            if (!widget.enabled) return;

            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: widget.firstDate ?? DateTime(2000),
              lastDate: widget.lastDate ?? DateTime(2101),
            );

            if (picked != null && picked != _selectedDate) {
              _handleDateChanged(picked);
            }
          },
          enabled: widget.enabled,
          onChanged: widget.onChange,
          readOnly: true,
          style: CustomStyle.textStyleBlack(context),
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            labelStyle: CustomStyle.textStyleBlack(context),
            filled: true,
            fillColor: colorScheme.surface,
            hintStyle: CustomStyle.textStyleBlack(context),
            focusedBorder: CustomStyle.focusBorder(context),
            enabledBorder: CustomStyle.focusErrorBorder(context),
            focusedErrorBorder: CustomStyle.focusErrorBorder(context),
            errorBorder: CustomStyle.focusErrorBorder(context),
            prefixIcon: Icon(widget.prefixIcon),
          ),
        ),
        const SizedBox(
          height: Dimensions.heightSize,
        ),
      ],
    );
  }
}
