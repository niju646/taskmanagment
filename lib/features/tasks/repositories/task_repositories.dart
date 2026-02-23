import 'package:interview/core/utils/task_mapper.dart';
import 'package:interview/features/tasks/data/model/task_hive_model.dart';
import 'package:interview/features/tasks/data/model/task_models.dart';
import 'package:interview/features/tasks/data/services/task_api_service.dart';
import 'package:interview/features/tasks/data/services/task_local_services.dart';

class TaskRepository {
  final TaskApiService _api = TaskApiService();
  final TaskLocalService _local = TaskLocalService();

  Future<List<TaskHiveModel>> fetchTasks() async {
    try {
      final List<Task> apiTasks = await _api.getTasks();

      final hiveTasks = apiTasks
          .map((task) => TaskMapper.toHive(task))
          .toList();

      await _local.saveTasks(hiveTasks);

      return hiveTasks;
    } catch (e) {
      return _local.getAllTasks();
    }
  }
}
