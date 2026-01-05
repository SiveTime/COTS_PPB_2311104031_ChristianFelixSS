import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../widgets/stats_card.dart';
import '../widgets/task_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/loading_widget.dart';
import 'task_list_page.dart';
import 'add_task_page.dart';
import 'task_detail_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskController>().loadTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Consumer<TaskController>(
          builder: (context, taskController, child) {
            if (taskController.isLoading && taskController.tasks.isEmpty) {
              return const LoadingWidget(message: 'Memuat data tugas...');
            }

            if (taskController.error != null) {
              return ErrorStateWidget(
                message: taskController.error!,
                onRetry: () => taskController.loadTasks(),
              );
            }

            return RefreshIndicator(
              onRefresh: () => taskController.loadTasks(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: AppSpacing.xl),
                    _buildStatsSection(taskController),
                    const SizedBox(height: AppSpacing.xl),
                    _buildNearestTasksSection(taskController),
                    const SizedBox(height: AppSpacing.xl),
                    _buildQuickActions(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tugas Besar',
          style: AppTypography.title20SemiBold.copyWith(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Text(
              'Daftar Tugas',
              style: AppTypography.body14Regular.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            GestureDetector(
              onTap: () => _navigateToTaskList(),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsSection(TaskController taskController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: StatsCard(
                title: 'Total Tugas',
                count: taskController.totalTasksCount.toString(),
                onTap: () => _navigateToTaskList(),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: StatsCard(
                title: 'Selesai',
                count: taskController.completedTasksCount.toString(),
                backgroundColor: AppColors.success.withOpacity(0.1),
                onTap: () => _navigateToTaskList(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNearestTasksSection(TaskController taskController) {
    final nearestTasks = _getNearestTasks(taskController.tasks);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tugas Terdekat',
              style: AppTypography.section16SemiBold.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            if (nearestTasks.isNotEmpty)
              GestureDetector(
                onTap: () => _navigateToTaskList(),
                child: Text(
                  'Lihat Semua',
                  style: AppTypography.body14Regular.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (nearestTasks.isEmpty)
          EmptyStateWidget(
            title: 'Tidak ada tugas terdekat',
            subtitle: 'Semua tugas sudah selesai atau belum ada tugas',
            icon: Icons.task_alt,
            action: CustomButton(
              text: 'Tambah Tugas',
              onPressed: () => _navigateToAddTask(),
              isFullWidth: false,
            ),
          )
        else
          ...nearestTasks
              .take(3)
              .map(
                (task) => TaskCard(
                  task: task,
                  onTap: () => _navigateToTaskDetail(task),
                  onToggleComplete: () => _toggleTaskCompletion(task),
                ),
              ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return CustomButton(
      text: 'Tambah Tugas',
      icon: Icons.add,
      onPressed: () => _navigateToAddTask(),
    );
  }

  List<Task> _getNearestTasks(List<Task> tasks) {
    final runningTasks = tasks.where((task) => !task.isDone).toList();
    runningTasks.sort((a, b) {
      try {
        final dateA = DateTime.parse(a.deadline);
        final dateB = DateTime.parse(b.deadline);
        return dateA.compareTo(dateB);
      } catch (e) {
        return 0;
      }
    });
    return runningTasks;
  }

  void _toggleTaskCompletion(Task task) {
    if (task.id != null) {
      context.read<TaskController>().toggleTaskCompletion(task.id!);
    }
  }

  void _navigateToTaskList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TaskListPage()),
    );
  }

  void _navigateToAddTask() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskPage()),
    );
  }

  void _navigateToTaskDetail(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailPage(taskId: task.id!)),
    );
  }
}
