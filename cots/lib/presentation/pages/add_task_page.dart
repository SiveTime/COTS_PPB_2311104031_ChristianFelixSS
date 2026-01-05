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

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime? _selectedDate;
  bool _isCompleted = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    _deadlineController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Tambah Tugas',
        actions: [
          TextButton(
            onPressed: _isSubmitting ? null : () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: AppTypography.body14Regular.copyWith(
                color: _isSubmitting
                    ? AppColors.textSecondary
                    : AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormHeader(),
              const SizedBox(height: AppSpacing.xl),
              _buildTaskForm(),
              const SizedBox(height: AppSpacing.xl),
              _buildCompletionSection(),
              const SizedBox(height: AppSpacing.xl),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
            ),
            child: const Icon(Icons.add_task, color: Colors.white, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Judul Tugas',
                  style: AppTypography.section16SemiBold.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'Judul tugas wajib diisi',
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

  Widget _buildTaskForm() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          CustomInput(
            label: 'Judul Tugas',
            hint: 'Masukkan judul tugas',
            controller: _titleController,
            isRequired: true,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Judul tugas wajib diisi';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomInput(
            label: 'Mata Kuliah',
            hint: 'Pilih mata kuliah',
            controller: _courseController,
            isRequired: true,
            readOnly: true,
            onTap: _showCourseSelector,
            suffixIcon: const Icon(
              Icons.arrow_drop_down,
              color: AppColors.textSecondary,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Mata kuliah wajib dipilih';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomInput(
            label: 'Deadline',
            hint: 'Pilih tanggal',
            controller: _deadlineController,
            isRequired: true,
            readOnly: true,
            onTap: _selectDate,
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: AppColors.textSecondary,
              size: 20,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Deadline wajib dipilih';
              }
              return null;
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomInput(
            label: 'Catatan',
            hint: 'Catatan tambahan (opsional)',
            controller: _noteController,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildCompletionSection() {
    return Container(
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
            'Status Penyelesaian',
            style: AppTypography.section16SemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          CustomCheckbox(
            value: _isCompleted,
            label: 'Tugas sudah selesai',
            onChanged: (value) {
              setState(() {
                _isCompleted = value ?? false;
              });
            },
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
    );
  }

  Widget _buildSubmitButton() {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: 'Batal',
            type: ButtonType.secondary,
            onPressed: _isSubmitting ? null : () => Navigator.pop(context),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: CustomButton(
            text: 'Simpan',
            onPressed: _isSubmitting ? null : _submitTask,
            isLoading: _isSubmitting,
          ),
        ),
      ],
    );
  }

  void _showCourseSelector() {
    final courses = [
      'Pemrograman Lanjut',
      'Rekayasa Perangkat Lunak',
      'Basis Data',
      'Sistem Operasi',
      'Jaringan Komputer',
      'Algoritma dan Struktur Data',
      'Pemrograman Web',
      'Mobile Development',
      'Kecerdasan Buatan',
      'Keamanan Siber',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusLarge),
        ),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    'Pilih Mata Kuliah',
                    style: AppTypography.section16SemiBold.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Expanded(
                    child: ListView.separated(
                      controller: scrollController,
                      itemCount: courses.length,
                      separatorBuilder: (context, index) =>
                          const Divider(color: AppColors.border, height: 1),
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          title: Text(
                            course,
                            style: AppTypography.body14Regular.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          onTap: () {
                            _courseController.text = course;
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _deadlineController.text = DateFormat('dd MMMM yyyy').format(picked);
      });
    }
  }

  void _submitTask() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final task = Task(
      title: _titleController.text.trim(),
      course: _courseController.text.trim(),
      deadline: _selectedDate!.toIso8601String().split(
        'T',
      )[0], // Format: YYYY-MM-DD
      status: _isCompleted ? TaskStatus.completed : TaskStatus.running,
      note: _noteController.text.trim(),
      isDone: _isCompleted,
    );

    final taskController = context.read<TaskController>();
    final success = await taskController.addTask(task);

    setState(() {
      _isSubmitting = false;
    });

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tugas berhasil ditambahkan',
            style: AppTypography.body14Regular.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context, true); // Return true to indicate task was added
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            taskController.error ?? 'Gagal menambahkan tugas',
            style: AppTypography.body14Regular.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}
