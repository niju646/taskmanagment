class Task {
  final int? id;
  final String title;
  final String? description;
  final bool isCompleted;
  final String priority;
  final String category;
  final DateTime? dueDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Task({
    this.id,
    required this.title,
    this.description,
    this.isCompleted = false,
    required this.priority,
    required this.category,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      isCompleted: json['is_completed'] ?? false,
      priority: json['priority'],
      category: json['category'],
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'])
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "is_completed": isCompleted,
      "priority": priority,
      "category": category,
      "due_date": dueDate?.toIso8601String(),
    };
  }
}
