import 'package:flutter/material.dart';
import 'package:qr_check_in/shared/resources/dimensions.dart';

class CustomStyle {
  static TextStyle layoutTitleText(BuildContext context) => TextStyle(
        fontSize: Dimensions.titleTextSize,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle layoutDescriptionText(BuildContext context) => TextStyle(
        fontSize: Dimensions.descriptionTextSize,
        color: Theme.of(context).colorScheme.onSurface.withAlpha(204),
        fontStyle: FontStyle.italic,
      );

  static TextStyle textStyleWhite(BuildContext context) => TextStyle(
        fontSize: Dimensions.defaultTextSize,
        color: Theme.of(context).colorScheme.onSurface,
      );

  static TextStyle textStyleBlack(BuildContext context) => TextStyle(
        fontSize: Dimensions.defaultTextSize,
        color: Theme.of(context).colorScheme.onPrimary,
      );

  static TextStyle hintTextStyleBlack(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.onSurface.withAlpha(80),
        fontSize: Dimensions.defaultTextSize,
        //white
      );

  static TextStyle listStyle(BuildContext context) => const TextStyle(
        color: Colors.white,
        fontSize: Dimensions.defaultTextSize,
      );

  static TextStyle defaultStyle(BuildContext context) => TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
        fontSize: Dimensions.largeTextSize,
      );

  static OutlineInputBorder focusBorder(BuildContext context) =>
      OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          width: 2.0,
        ),
      );

  static OutlineInputBorder focusErrorBorder(BuildContext context) =>
      OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.error.withOpacity(0.1),
          width: 1.0,
        ),
      );

  static OutlineInputBorder searchBox(BuildContext context) =>
      OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
          width: 1.0,
        ),
      );

  static TextStyle tableHeader(BuildContext context, double fontSize) =>
      TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: fontSize,
        color: Theme.of(context).colorScheme.onSurface,
        overflow: TextOverflow.ellipsis,
      );

  static ButtonStyle confirmModalButton(BuildContext context) =>
      TextButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.onError,
          foregroundColor: Theme.of(context).colorScheme.surface);

  static TextStyle styleBoldMiddle(BuildContext context) => TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18.5,
        color: Theme.of(context).colorScheme.surface,
      );

  static TextStyle styleBoldLarge(BuildContext context) => TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
        color: Theme.of(context).colorScheme.onSurface,
      );
}
