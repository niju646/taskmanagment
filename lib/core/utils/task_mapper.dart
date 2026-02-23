import 'package:interview/features/tasks/data/model/task_hive_model.dart';
import 'package:interview/features/tasks/data/model/task_models.dart';

class TaskMapper {
  static TaskHiveModel toHive(Task task) {
    return TaskHiveModel(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      priority: task.priority,
      category: task.category,
      dueDate: task.dueDate,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      isSynced: true,
    );
  }

  static Task fromHive(TaskHiveModel task) {
    return Task(
      id: task.id,
      title: task.title,
      description: task.description,
      isCompleted: task.isCompleted,
      priority: task.priority,
      category: task.category,
      dueDate: task.dueDate,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
    );
  }
}
