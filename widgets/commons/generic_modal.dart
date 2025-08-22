import 'package:flutter/material.dart';
import 'package:qr_check_in/shared/resources/custom_style.dart';

class GenericModal extends StatelessWidget {
  final Widget content;
  final VoidCallback? onAccept;
  final VoidCallback? onCancel;
  final String title;
  final String acceptText;
  final String cancelText;
  final String subtitle;
  final bool showAcceptButton;
  final bool showCancelButton;
  final bool isLoading;
  final ButtonStyle? cancelStyle;
  final ButtonStyle? acceptStyle;
  final TextStyle? acceptTextStyle;
  final TextStyle? cancelTextStyle;

  const GenericModal({
    super.key,
    required this.content,
    this.onAccept,
    this.onCancel,
    this.title = 'Confirmación',
    this.acceptText = 'Aceptar',
    this.cancelText = 'Cancelar',
    this.subtitle = '',
    this.showAcceptButton = true,
    this.showCancelButton = true,
    this.cancelStyle,
    this.acceptStyle,
    this.cancelTextStyle,
    this.acceptTextStyle,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      // title with title and subtitle
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: CustomStyle.styleBoldLarge(context)),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: CustomStyle.hintTextStyleBlack(context),
          ),
        ],
      ),

      content: content,
      actions: [
        showCancelButton
            ? SizedBox(
                width: 120,
                child: ElevatedButton(
                  style: cancelStyle ?? CustomStyle.confirmModalButton(context),
                  onPressed: () {
                    onCancel?.call();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    cancelText,
                    style: cancelTextStyle ?? TextStyle(
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              )
            : const SizedBox.shrink(),
        showAcceptButton
            ? SizedBox(
                width: 120,
                child: ElevatedButton(
                  style: acceptStyle ?? TextButton.styleFrom(
                      backgroundColor: colorScheme.primaryFixed,
                      foregroundColor: colorScheme.surface),
                  onPressed: isLoading
                      ? null
                      : () {
                          onAccept?.call();
                          //Navigator.of(context).pop();
                        },
                  child: Text(
                    acceptText,
                    style: acceptTextStyle ?? TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
