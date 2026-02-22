import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interview/features/tasks/data/model/task_models.dart';
import '../../data/services/task_service.dart';

/// SERVICE PROVIDER
final taskServiceProvider = Provider<TaskService>((ref) {
  final user = FirebaseAuth.instance.currentUser;

  if (user == null) {
    throw Exception("User not logged in");
  }
  return TaskService(user.uid);
});

/// STATE
class TaskState {
  final bool isLoading;
  final List<Task> tasks;
  final String? error;

  TaskState({this.isLoading = false, this.tasks = const [], this.error});

  TaskState copyWith({bool? isLoading, List<Task>? tasks, String? error}) {
    return TaskState(
      isLoading: isLoading ?? this.isLoading,
      tasks: tasks ?? this.tasks,
      error: error,
    );
  }
}

/// PROVIDER
final taskProvider = StateNotifierProvider<TaskNotifier, TaskState>(
  (ref) => TaskNotifier(ref),
);

/// NOTIFIER
class TaskNotifier extends StateNotifier<TaskState> {
  final Ref ref;

  TaskNotifier(this.ref) : super(TaskState()) {
    fetchTasks();
  }

  /// FETCH
  Future<void> fetchTasks() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final service = ref.read(taskServiceProvider);
      final response = await service.fetchTasks();

      if (response.statusCode == 200) {
        final List data = response.data["data"]; // ✅ FIX HERE

        final tasks = data.map((e) => Task.fromJson(e)).toList();

        state = state.copyWith(tasks: tasks, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Failed to fetch tasks",
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// CREATE
  Future<void> createTask(Task task) async {
    state = state.copyWith(isLoading: true);

    try {
      final service = ref.read(taskServiceProvider);
      final response = await service.createTask(task);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newTask = Task.fromJson(response.data);

        state = state.copyWith(
          tasks: [...state.tasks, newTask],
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  /// DELETE
  Future<void> deleteTask(int id) async {
    try {
      final service = ref.read(taskServiceProvider);
      await service.deleteTask(id);

      state = state.copyWith(
        tasks: state.tasks.where((t) => t.id != id).toList(),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  /// UPDATE
  Future<void> updateTask(Task task) async {
    state = state.copyWith(isLoading: true);

    try {
      final service = ref.read(taskServiceProvider);
      final response = await service.updateTask(task);

      if (response.statusCode == 200) {
        final updatedTask = Task.fromJson(response.data);

        final updatedList = state.tasks.map((t) {
          return t.id == updatedTask.id ? updatedTask : t;
        }).toList();

        state = state.copyWith(tasks: updatedList, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }
}
