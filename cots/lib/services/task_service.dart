import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';
import '../config/api_config.dart';

class TaskService {
  // Get all tasks
  Future<List<Task>> getAllTasks() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.tasksEndpoint}?select=*'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tasks: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching tasks: $e');
    }
  }

  // Get tasks by status
  Future<List<Task>> getTasksByStatus(String status) async {
    try {
      final response = await http.get(
        Uri.parse(
          '${ApiConfig.baseUrl}${ApiConfig.tasksEndpoint}?select=*&status=eq.$status',
        ),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Task.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load tasks by status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching tasks by status: $e');
    }
  }

  // Add new task
  Future<Task> addTask(Task task) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.tasksEndpoint}'),
        headers: ApiConfig.headers,
        body: json.encode(task.toJson()),
      );

      if (response.statusCode == 201) {
        final List<dynamic> data = json.decode(response.body);
        return Task.fromJson(data.first);
      } else {
        throw Exception('Failed to add task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding task: $e');
    }
  }

  // Update task
  Future<Task> updateTask(int taskId, Map<String, dynamic> updates) async {
    try {
      final response = await http.patch(
        Uri.parse(
          '${ApiConfig.baseUrl}${ApiConfig.tasksEndpoint}?id=eq.$taskId',
        ),
        headers: ApiConfig.headers,
        body: json.encode(updates),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return Task.fromJson(data.first);
      } else {
        throw Exception('Failed to update task: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error updating task: $e');
    }
  }

  // Toggle task completion
  Future<Task> toggleTaskCompletion(int taskId, bool isDone) async {
    final updates = {
      'is_done': isDone,
      'status': isDone ? TaskStatus.completed : TaskStatus.running,
    };

    return await updateTask(taskId, updates);
  }

  // Update task note
  Future<Task> updateTaskNote(int taskId, String note) async {
    final updates = {'note': note};
    return await updateTask(taskId, updates);
  }
}
