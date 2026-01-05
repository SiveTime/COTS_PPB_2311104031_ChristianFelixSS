import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_input.dart';
import '../widgets/custom_checkbox.dart';
import '../widgets/loading_widget.dart';

class TaskDetailPage extends StatefulWidget {
  final int taskId;

  const TaskDetailPage({super.key, required this.taskId});

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  final TextEditingController _noteController = TextEditingController();
  bool _isEditing = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTaskData();
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _loadTaskData() {
    final taskController = context.read<TaskController>();
    final task = taskController.getTaskById(widget.taskId);
    if (task != null) {
      _noteController.text = task.note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Detail Tugas',
        actions: [
          TextButton(
            onPressed: _isUpdating ? null : _toggleEditMode,
            child: Text(
              _isEditing ? 'Batal' : 'Edit',
              style: AppTypography.body14Regular.copyWith(
                color: _isUpdating
                    ? AppColors.textSecondary
                    : AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<TaskController>(
        builder: (context, taskController, child) {
          final task = taskController.getTaskById(widget.taskId);

          if (task == null) {
            return const EmptyStateWidget(
              title: 'Tugas tidak ditemukan',
              subtitle: 'Tugas mungkin sudah dihapus atau tidak ada',
              icon: Icons.search_off,
            );
          }

          if (taskController.isLoading && _isUpdating) {
            return const LoadingWidget(message: 'Menyimpan perubahan...');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.screenPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTaskHeader(task),
                const SizedBox(height: AppSpacing.xl),
                _buildTaskInfo(task),
                const SizedBox(height: AppSpacing.xl),
                _buildTaskCompletion(task, taskController),
                const SizedBox(height: AppSpacing.xl),
                _buildTaskNotes(task),
                const SizedBox(height: AppSpacing.xl),
                if (_isEditing) _buildSaveButton(taskController),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTaskHeader(Task task) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Judul Tugas Section - Full Width
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Judul Tugas',
                  style: AppTypography.body14Regular.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  task.title,
                  style: AppTypography.title20SemiBold.copyWith(
                    color: AppColors.textPrimary,
                    decoration: task.isDone ? TextDecoration.lineThrough : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Mata Kuliah Section - Full Width
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mata Kuliah',
                  style: AppTypography.body14Regular.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  task.course,
                  style: AppTypography.section16SemiBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskInfo(Task task) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Deadline Section - Full Width
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Deadline',
                  style: AppTypography.body14Regular.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  _formatDate(task.deadline),
                  style: AppTypography.section16SemiBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          // Status Section - Full Width
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status',
                  style: AppTypography.body14Regular.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          task.status,
                        ).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusSmall,
                        ),
                      ),
                      child: Text(
                        _getStatusText(task.status),
                        style: AppTypography.caption12Regular.copyWith(
                          color: _getStatusColor(task.status),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCompletion(Task task, TaskController taskController) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Penyelesaian',
            style: AppTypography.section16SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCheckbox(
                  value: task.isDone,
                  label: 'Tugas sudah selesai',
                  onChanged: _isUpdating
                      ? null
                      : (value) => _toggleTaskCompletion(taskController),
                  activeColor: AppColors.success,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Centang jika tugas sudah final.',
                  style: AppTypography.caption12Regular.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskNotes(Task task) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Catatan',
            style: AppTypography.section16SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (_isEditing)
            CustomInput(
              label: '',
              hint: 'Catatan tambahan (opsional)',
              controller: _noteController,
              maxLines: 4,
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                task.note.isEmpty ? 'Tidak ada catatan' : task.note,
                style: AppTypography.body14Regular.copyWith(
                  color: task.note.isEmpty
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(TaskController taskController) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: 'Simpan Perubahan',
        onPressed: _isUpdating ? null : () => _saveChanges(taskController),
        isLoading: _isUpdating,
      ),
    );
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        // Reset note controller when canceling edit
        _loadTaskData();
      }
    });
  }

  void _toggleTaskCompletion(TaskController taskController) async {
    setState(() {
      _isUpdating = true;
    });

    final success = await taskController.toggleTaskCompletion(widget.taskId);

    setState(() {
      _isUpdating = false;
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Status tugas berhasil diperbarui',
            style: AppTypography.body14Regular.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _saveChanges(TaskController taskController) async {
    setState(() {
      _isUpdating = true;
    });

    final success = await taskController.updateTaskNote(
      widget.taskId,
      _noteController.text.trim(),
    );

    setState(() {
      _isUpdating = false;
      _isEditing = false;
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Catatan berhasil disimpan',
            style: AppTypography.body14Regular.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context, true); // Return true to indicate changes were made
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal menyimpan perubahan',
            style: AppTypography.body14Regular.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
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

  String _getStatusText(String status) {
    switch (status) {
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
      return DateFormat('dd MMMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
}
