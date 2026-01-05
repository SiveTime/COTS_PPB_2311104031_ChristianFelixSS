import 'package:flutter/material.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';

class CustomCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String? label;
  final Color? activeColor;

  const CustomCheckbox({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged?.call(!value),
      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: value
                    ? (activeColor ?? AppColors.primary)
                    : Colors.transparent,
                border: Border.all(
                  color: value
                      ? (activeColor ?? AppColors.primary)
                      : AppColors.border,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: value
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : null,
            ),
            if (label != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  label!,
                  style: AppTypography.body14Regular.copyWith(
                    color: AppColors.textPrimary,
                    decoration: value ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
