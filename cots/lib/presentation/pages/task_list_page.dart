import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../design_system/colors.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../controllers/task_controller.dart';
import '../../models/task.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/filter_chips.dart';
import '../widgets/task_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/custom_button.dart';
import 'add_task_page.dart';
import 'task_detail_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  TaskFilter _selectedFilter = TaskFilter.all;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskController>().loadTasks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Daftar Tugas',
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: AppColors.primary),
            onPressed: () => _navigateToAddTask(),
          ),
        ],
      ),
      body: Consumer<TaskController>(
        builder: (context, taskController, child) {
          if (taskController.isLoading && taskController.tasks.isEmpty) {
            return const LoadingWidget(message: 'Memuat daftar tugas...');
          }

          if (taskController.error != null) {
            return ErrorStateWidget(
              message: taskController.error!,
              onRetry: () => taskController.loadTasks(),
            );
          }

          final filteredTasks = _getFilteredTasks(taskController.tasks);

          return Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: AppSpacing.lg),
              FilterChips(
                selectedFilter: _selectedFilter,
                onFilterChanged: (filter) {
                  setState(() {
                    _selectedFilter = filter;
                  });
                },
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => taskController.loadTasks(),
                  child: filteredTasks.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.screenPadding,
                          ),
                          itemCount: filteredTasks.length,
                          itemBuilder: (context, index) {
                            final task = filteredTasks[index];
                            return TaskCard(
                              task: task,
                              onTap: () => _navigateToTaskDetail(task),
                              onToggleComplete: () =>
                                  _toggleTaskCompletion(task),
                            );
                          },
                        ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTask(),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.screenPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
          });
        },
        style: AppTypography.body14Regular.copyWith(
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Cari tugas atau mata kuliah...',
          hintStyle: AppTypography.body14Regular.copyWith(
            color: AppColors.textSecondary,
          ),
          prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String title;
    String subtitle;
    IconData icon;

    switch (_selectedFilter) {
      case TaskFilter.all:
        title = 'Belum ada tugas';
        subtitle = 'Tambah tugas pertama Anda untuk memulai';
        icon = Icons.assignment_outlined;
        break;
      case TaskFilter.running:
        title = 'Tidak ada tugas berjalan';
        subtitle = 'Semua tugas sudah selesai atau belum ada tugas';
        icon = Icons.play_circle_outline;
        break;
      case TaskFilter.completed:
        title = 'Belum ada tugas selesai';
        subtitle = 'Selesaikan tugas untuk melihatnya di sini';
        icon = Icons.task_alt;
        break;
      case TaskFilter.overdue:
        title = 'Tidak ada tugas terlambat';
        subtitle = 'Pertahankan! Semua tugas tepat waktu';
        icon = Icons.schedule;
        break;
    }

    return EmptyStateWidget(
      title: title,
      subtitle: subtitle,
      icon: icon,
      action: _selectedFilter == TaskFilter.all
          ? CustomButton(
              text: 'Tambah Tugas',
              onPressed: () => _navigateToAddTask(),
              isFullWidth: false,
            )
          : null,
    );
  }

  List<Task> _getFilteredTasks(List<Task> tasks) {
    List<Task> filtered = tasks;

    // Filter by status
    switch (_selectedFilter) {
      case TaskFilter.running:
        filtered = tasks
            .where((task) => task.status == TaskStatus.running)
            .toList();
        break;
      case TaskFilter.completed:
        filtered = tasks
            .where((task) => task.status == TaskStatus.completed)
            .toList();
        break;
      case TaskFilter.overdue:
        filtered = tasks
            .where((task) => task.status == TaskStatus.overdue)
            .toList();
        break;
      case TaskFilter.all:
        // No filtering needed
        break;
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((task) {
        return task.title.toLowerCase().contains(_searchQuery) ||
            task.course.toLowerCase().contains(_searchQuery) ||
            task.note.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Sort by deadline (nearest first)
    filtered.sort((a, b) {
      try {
        final dateA = DateTime.parse(a.deadline);
        final dateB = DateTime.parse(b.deadline);
        return dateA.compareTo(dateB);
      } catch (e) {
        return 0;
      }
    });

    return filtered;
  }

  void _toggleTaskCompletion(Task task) {
    if (task.id != null) {
      context.read<TaskController>().toggleTaskCompletion(task.id!);
    }
  }

  void _navigateToAddTask() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTaskPage()),
    );

    if (result == true) {
      // Refresh the list if a task was added
      context.read<TaskController>().loadTasks();
    }
  }

  void _navigateToTaskDetail(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskDetailPage(taskId: task.id!)),
    );

    if (result == true) {
      // Refresh the list if task was updated
      context.read<TaskController>().loadTasks();
    }
  }
}
