import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:interview/features/tasks/data/model/task_models.dart';
import 'package:interview/features/tasks/data/provider/task_provider.dart';
import 'package:interview/features/tasks/data/widgets/common_text.dart';
import 'package:interview/features/tasks/data/widgets/common_text_field.dart';
import 'package:interview/features/tasks/data/widgets/custom_snack_bar.dart';

class TaskDetailsScreen extends ConsumerStatefulWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  ConsumerState<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends ConsumerState<TaskDetailsScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late TextEditingController dueDateController;

  late String selectedPriority;
  late String selectedCategory;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(text: widget.task.title);
    descriptionController = TextEditingController(
      text: widget.task.description,
    );

    dueDateController = TextEditingController(
      text: widget.task.dueDate != null
          ? widget.task.dueDate!.toIso8601String().split("T").first
          : "",
    );

    selectedPriority = widget.task.priority;
    selectedCategory = widget.task.category;
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    dueDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Task Details"),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CommonText(text: "Enter title:"),
              SizedBox(height: 10),
              CommonTextField(hintText: "Title", controller: titleController),
              const SizedBox(height: 10),
              CommonText(text: "Enter description:"),
              SizedBox(height: 10),
              CommonTextField(
                hintText: "Description",
                controller: descriptionController,
              ),
              const SizedBox(height: 10),
              CommonText(text: "Select mode:"),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: selectedPriority,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                items: ["Low", "Medium", "High"]
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedPriority = value!;
                  });
                },
              ),
              const SizedBox(height: 10),
              CommonText(text: "select category:"),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                initialValue: selectedCategory,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                items:
                    [
                          "Work",
                          "Personal",
                          "Health",
                          "Finance",
                          "Education",
                          "Shopping",
                          "Travel",
                          "Others",
                        ]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 10),
              CommonText(text: "select date:"),
              SizedBox(height: 10),
              CommonTextField(
                hintText: 'Select Due Date',
                controller: dueDateController,
                readOnly: true,
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null) {
                    dueDateController.text = pickedDate
                        .toIso8601String()
                        .split("T")
                        .first;
                  }
                },
              ),

              const SizedBox(height: 20),

              taskState.isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: 400,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () async {
                          if (titleController.text.trim().isEmpty) {
                            CustomSnackbar.show(
                              context,
                              message: "Title cannot be empty",
                              type: SnackbarType.failure,
                            );
                            return;
                          }

                          final updatedTask = Task(
                            id: widget.task.id,
                            title: titleController.text.trim(),
                            description:
                                descriptionController.text.trim().isNotEmpty
                                ? descriptionController.text.trim()
                                : null,
                            priority: selectedPriority,
                            category: selectedCategory,
                            dueDate: dueDateController.text.isNotEmpty
                                ? DateTime.tryParse(dueDateController.text)
                                : null,
                            isCompleted: widget.task.isCompleted,
                          );

                          setState(() {}); // optional: force rebuild if needed

                          await ref
                              .read(taskProvider.notifier)
                              .updateTask(updatedTask);

                          if (!context.mounted) return;

                          CustomSnackbar.show(
                            context,
                            message: "Task updated successfully",
                            type: SnackbarType.success,
                          );
                          context.pop();
                        },
                        child: const Text(
                          "Update Task",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
