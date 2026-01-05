import 'package:flutter/foundation.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class TaskController extends ChangeNotifier {
  final TaskService _taskService = TaskService();

  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Get tasks by status
  List<Task> get runningTasks =>
      _tasks.where((task) => task.status == TaskStatus.running).toList();
  List<Task> get completedTasks =>
      _tasks.where((task) => task.status == TaskStatus.completed).toList();
  List<Task> get overdueTasks =>
      _tasks.where((task) => task.status == TaskStatus.overdue).toList();

  // Get task counts
  int get totalTasksCount => _tasks.length;
  int get completedTasksCount => completedTasks.length;
  int get runningTasksCount => runningTasks.length;
  int get overdueTasksCount => overdueTasks.length;

  // Load all tasks
  Future<void> loadTasks() async {
    _setLoading(true);
    _setError(null);

    try {
      _tasks = await _taskService.getAllTasks();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Load tasks by status
  Future<void> loadTasksByStatus(String status) async {
    _setLoading(true);
    _setError(null);

    try {
      _tasks = await _taskService.getTasksByStatus(status);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  // Add new task
  Future<bool> addTask(Task task) async {
    _setLoading(true);
    _setError(null);

    try {
      final newTask = await _taskService.addTask(task);
      _tasks.add(newTask);
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Toggle task completion
  Future<bool> toggleTaskCompletion(int taskId) async {
    _setLoading(true);
    _setError(null);

    try {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex == -1) {
        throw Exception('Task not found');
      }

      final currentTask = _tasks[taskIndex];
      final updatedTask = await _taskService.toggleTaskCompletion(
        taskId,
        !currentTask.isDone,
      );

      _tasks[taskIndex] = updatedTask;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Update task note
  Future<bool> updateTaskNote(int taskId, String note) async {
    _setLoading(true);
    _setError(null);

    try {
      final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex == -1) {
        throw Exception('Task not found');
      }

      final updatedTask = await _taskService.updateTaskNote(taskId, note);
      _tasks[taskIndex] = updatedTask;
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get task by ID
  Task? getTaskById(int id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
