import 'package:qr_check_in/shared/resources/custom_style.dart';
import 'package:qr_check_in/shared/resources/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomTimePicker extends StatefulWidget {
  final TimeOfDay initialTime;
  final FormFieldValidator<String>? validator;
  final TextEditingController controller;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChange;
  final VoidCallback? onTap;
  final bool enabled;

  const CustomTimePicker({
    super.key,
    required this.initialTime,
    required this.controller,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChange,
    this.onTap,
    this.enabled = true,
  });

  @override
  State<CustomTimePicker> createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late TimeOfDay _selectedTime;

  String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt); // 24-hour format
  }

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime;
    widget.controller.text = formatTime(_selectedTime);
  }

  void _handleTimeChanged(TimeOfDay newTime) {
    setState(() {
      _selectedTime = newTime;
    });
    widget.controller.text = formatTime(newTime);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
        ),
        const SizedBox(height: Dimensions.heightSize * 0.5),
        TextFormField(
          onTap: () async {
            if (!widget.enabled) return;

            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: _selectedTime,
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.dark(
                      primary: colorScheme.primary,
                      onPrimary: colorScheme.onPrimary,
                      surface: colorScheme.surface,
                      onSurface: colorScheme.onSurface,
                    ),
                    timePickerTheme: TimePickerThemeData(
                      dialHandColor: colorScheme.primary,
                      dialTextColor: colorScheme.onSurface,
                      entryModeIconColor: colorScheme.primary,
                      hourMinuteTextColor: colorScheme.onSurface,
                      hourMinuteColor: colorScheme.surface,
                      dayPeriodColor: colorScheme.primary.withOpacity(0.1),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (picked != null && picked != _selectedTime) {
              _handleTimeChanged(picked);
            }
          },
          enabled: widget.enabled,
          onChanged: widget.onChange,
          readOnly: true,
          style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hintText,
            contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            labelStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface),
            filled: true,
            fillColor: colorScheme.surface,
            hintStyle: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withOpacity(0.6)),
            focusedBorder: CustomStyle.focusBorder(context),
            enabledBorder: CustomStyle.focusErrorBorder(context),
            focusedErrorBorder: CustomStyle.focusErrorBorder(context),
            errorBorder: CustomStyle.focusErrorBorder(context),
            prefixIcon: Icon(widget.prefixIcon, color: colorScheme.onPrimary),
          ),
        ),
        const SizedBox(height: Dimensions.heightSize),
      ],
    );
  }
}
