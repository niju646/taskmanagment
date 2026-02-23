import 'package:interview/core/network/api_services.dart';
import 'package:interview/features/tasks/data/model/task_models.dart';

class TaskApiService {
  /// GET all tasks
  Future<List<Task>> getTasks() async {
    final response = await ApiServices.get("/tasks");

    if (response.statusCode == 200) {
      final List data = response.data["data"];
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception("Failed to fetch tasks");
    }
  }

  /// CREATE task
  Future<Task> createTask(Task task) async {
    final response = await ApiServices.post("/tasks", task.toJson());

    if (response.statusCode == 201) {
      return Task.fromJson(response.data["data"]);
    } else {
      throw Exception("Failed to create task");
    }
  }

  /// UPDATE task
  Future<Task> updateTask(int id, Task task) async {
    final response = await ApiServices.put("/tasks/$id", task.toJson());

    if (response.statusCode == 200) {
      return Task.fromJson(response.data["data"]);
    } else {
      throw Exception("Failed to update task");
    }
  }

  /// DELETE task
  Future<void> deleteTask(int id) async {
    final response = await ApiServices.delete("/tasks/$id");

    if (response.statusCode != 200) {
      throw Exception("Failed to delete task");
    }
  }
}
