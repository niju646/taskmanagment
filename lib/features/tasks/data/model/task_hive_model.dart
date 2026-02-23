import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class TaskHiveModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  bool isCompleted;

  @HiveField(4)
  String priority;

  @HiveField(5)
  String category;

  @HiveField(6)
  DateTime? dueDate;

  @HiveField(7)
  DateTime? createdAt;

  @HiveField(8)
  DateTime? updatedAt;

  @HiveField(9)
  bool isSynced; // important for offline sync

  TaskHiveModel({
    this.id,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.priority,
    required this.category,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
    this.isSynced = true,
  });
}
