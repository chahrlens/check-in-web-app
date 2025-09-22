import 'package:flutter/material.dart';
import 'color_pallete.dart';

extension CustomButtonStyles on BuildContext {
  // Existing styles for IconButton
  ButtonStyle get primaryButtonStyle => IconButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.primary,
    hoverColor: AppColors.onPrimary.withOpacity(0.15),
    shape: const CircleBorder(),
  );

  ButtonStyle get editButtonStyle => IconButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.warning,
    hoverColor: AppColors.warning.withOpacity(0.15),
    shape: const CircleBorder(),
  );

  ButtonStyle get deleteButtonStyle => IconButton.styleFrom(
    backgroundColor: Colors.transparent,
    foregroundColor: AppColors.error,
    hoverColor: AppColors.error.withOpacity(0.15),
    shape: const CircleBorder(),
  );

  // New styles for ElevatedButton
  ButtonStyle get elevatedPrimaryButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  ButtonStyle get elevatedDeleteButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.error,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  ButtonStyle get elevatedEditButtonStyle => ElevatedButton.styleFrom(
    backgroundColor: AppColors.warning,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );
}
