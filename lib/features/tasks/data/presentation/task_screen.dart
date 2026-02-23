import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:interview/features/tasks/data/model/task_models.dart';
import 'package:interview/features/tasks/data/provider/task_provider.dart';
import 'package:interview/features/tasks/data/widgets/common_text.dart';
import 'package:interview/features/tasks/data/widgets/common_text_field.dart';
import 'package:interview/features/tasks/data/widgets/custom_snack_bar.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priorityController = TextEditingController();
  final categoryController = TextEditingController();
  final dueDateController = TextEditingController();

  String selectedPriority = "Low";
  String selectedCategory = "Work";

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    priorityController.dispose();
    categoryController.dispose();
    dueDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Task", style: TextStyle(fontSize: 20)),

        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CommonText(text: "Enter Title:"),
              const SizedBox(height: 10),
              CommonTextField(hintText: 'Title', controller: titleController),
              const SizedBox(height: 10),
              CommonText(text: "Enter description:"),
              const SizedBox(height: 10),
              CommonTextField(
                hintText: 'Description',
                controller: descriptionController,
              ),
              const SizedBox(height: 10),
              CommonText(text: "select mode:"),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                initialValue: selectedPriority,
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
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                initialValue: selectedCategory,
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
              const SizedBox(height: 10),
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
                    final formattedDate =
                        "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";

                    dueDateController.text = formattedDate;
                  }
                },
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: 400,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () async {
                    if (titleController.text.isEmpty) return;

                    await ref
                        .read(taskProvider.notifier)
                        .createTask(
                          Task(
                            title: titleController.text,
                            description: descriptionController.text,
                            priority: selectedPriority,
                            category: selectedCategory,
                            dueDate: DateTime.tryParse(dueDateController.text),
                          ),
                        );
                    if (!context.mounted) return;
                    CustomSnackbar.show(
                      context,
                      message: "Task created Successfully",
                      type: SnackbarType.success,
                    );

                    /// Clear fields
                    titleController.clear();
                    descriptionController.clear();
                    priorityController.clear();
                    categoryController.clear();
                    dueDateController.clear();

                    context.pop();
                  },
                  child: const Text(
                    "Create",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
