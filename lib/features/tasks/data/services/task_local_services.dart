import 'package:hive/hive.dart';
import 'package:interview/features/tasks/data/model/task_hive_model.dart';

class TaskLocalService {
  final Box<TaskHiveModel> _box = Hive.box<TaskHiveModel>('tasksBox');

  /// Get all tasks
  List<TaskHiveModel> getAllTasks() {
    return _box.values.toList();
  }

  /// Save full task list (used after API fetch)
  Future<void> saveTasks(List<TaskHiveModel> tasks) async {
    await _box.clear();
    for (var task in tasks) {
      await _box.put(task.id, task);
    }
  }

  /// Add single task
  Future<void> addTask(TaskHiveModel task) async {
    await _box.put(task.id, task);
  }

  /// Update task
  Future<void> updateTask(TaskHiveModel task) async {
    await _box.put(task.id, task);
  }

  /// Delete task
  Future<void> deleteTask(int id) async {
    await _box.delete(id);
  }

  /// Clear all tasks
  Future<void> clear() async {
    await _box.clear();
  }
}
