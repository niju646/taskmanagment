import 'package:dio/dio.dart';
import 'package:interview/core/network/api_services.dart';
import 'package:interview/core/utils/urls/api_end_points.dart';
import 'package:interview/features/tasks/data/model/task_models.dart';

class TaskService {
  final String userId;

  TaskService(this.userId);
  Future<Response> fetchTasks({int skip = 0, int limit = 10}) async {
    final response = await ApiServices.get(
      "${ApiEndPoints.fetchTasks}/?user_id=$userId&skip=$skip&limit=$limit",
    );
    return response;
  }

  //create task
  Future<Response> createTask(Task task) async {
    final response = await ApiServices.post(
      "${ApiEndPoints.createTask}/?user_id=$userId",
      task.toJson(),
    );
    return response;
  }

  // update task
  Future<Response> updateTask(Task task) async {
    final response = await ApiServices.put(
      "${ApiEndPoints.updateTask}/${task.id}?user_id=$userId",
      task.toJson(),
    );

    return response;
  }

  //delete task
  Future<Response> deleteTask(int id) async {
    final response = await ApiServices.delete(
      "${ApiEndPoints.deleteTask}/$id?user_id=$userId",
    );

    return response;
  }
}
