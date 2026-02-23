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
  final bool isFetchingMore;
  final bool hasMore;
  final int skip;
  final int limit;
  final List<Task> tasks;
  final String? error;

  TaskState({
    this.isLoading = false,
    this.isFetchingMore = false,
    this.hasMore = true,
    this.skip = 0,
    this.limit = 10,
    this.tasks = const [],
    this.error,
  });

  TaskState copyWith({
    bool? isLoading,
    bool? isFetchingMore,
    bool? hasMore,
    int? skip,
    int? limit,
    List<Task>? tasks,
    String? error,
  }) {
    return TaskState(
      isLoading: isLoading ?? this.isLoading,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasMore: hasMore ?? this.hasMore,
      skip: skip ?? this.skip,
      limit: limit ?? this.limit,
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

  TaskNotifier(this.ref) : super(TaskState());

  /// FETCH
  Future<void> fetchTasks({bool isLoadMore = false}) async {
    if (state.isFetchingMore || !state.hasMore) return;

    if (isLoadMore) {
      state = state.copyWith(isFetchingMore: true);
    } else {
      state = state.copyWith(isLoading: true, skip: 0, hasMore: true);
    }

    try {
      final service = ref.read(taskServiceProvider);

      final response = await service.fetchTasks(
        skip: isLoadMore ? state.skip : 0,
        limit: state.limit,
      );

      if (response.statusCode == 200) {
        final List data = response.data["data"];

        final newTasks = data.map((e) => Task.fromJson(e)).toList();

        final allTasks = isLoadMore ? [...state.tasks, ...newTasks] : newTasks;

        state = state.copyWith(
          tasks: allTasks,
          isLoading: false,
          isFetchingMore: false,
          skip: allTasks.length,
          hasMore: newTasks.length == state.limit,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isFetchingMore: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    await fetchTasks(isLoadMore: true);
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

      if (response.statusCode == 200 || response.statusCode == 201) {
        final updatedTask = Task.fromJson(response.data);
        await fetchTasks();
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
