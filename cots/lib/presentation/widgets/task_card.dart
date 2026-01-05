import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../models/task.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onToggleComplete;
  final bool showCheckbox;

  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onToggleComplete,
    this.showCheckbox = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showCheckbox) ...[
                  _buildStatusIndicator(),
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: AppTypography.section16SemiBold.copyWith(
                          color: AppColors.textPrimary,
                          decoration: task.isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        task.course,
                        style: AppTypography.body14Regular.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Text(
                            'Deadline: ${_formatDate(task.deadline)}',
                            style: AppTypography.caption12Regular.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          _buildStatusChip(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    return GestureDetector(
      onTap: onToggleComplete,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: task.isDone ? _getStatusColor() : Colors.transparent,
          border: Border.all(color: _getStatusColor(), width: 2),
        ),
        child: task.isDone
            ? const Icon(Icons.check, size: 12, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
      ),
      child: Text(
        _getStatusText(),
        style: AppTypography.caption12Regular.copyWith(
          color: _getStatusColor(),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (task.status) {
      case TaskStatus.running:
        return AppColors.statusRunning;
      case TaskStatus.completed:
        return AppColors.statusCompleted;
      case TaskStatus.overdue:
        return AppColors.statusOverdue;
      default:
        return AppColors.statusRunning;
    }
  }

  String _getStatusText() {
    switch (task.status) {
      case TaskStatus.running:
        return 'Berjalan';
      case TaskStatus.completed:
        return 'Selesai';
      case TaskStatus.overdue:
        return 'Terlambat';
      default:
        return 'Berjalan';
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
