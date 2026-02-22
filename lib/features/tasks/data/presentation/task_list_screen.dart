import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:interview/core/routes/router_constants.dart';
import 'package:interview/features/tasks/data/provider/task_provider.dart';
import 'package:interview/features/tasks/data/widgets/common_card.dart';
import 'package:interview/features/tasks/data/widgets/custom_snack_bar.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  Future<void> refreshData() async {
    await Future.wait([ref.read(taskProvider.notifier).fetchTasks()]);
  }

  @override
  Widget build(BuildContext context) {
    final taskState = ref.watch(taskProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Tasks"),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: RefreshIndicator(
          onRefresh: refreshData,
          child: Column(
            children: [
              Expanded(
                child: taskState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : taskState.tasks.isEmpty
                    ? const Center(child: Text("No Tasks Found"))
                    : ListView.builder(
                        itemCount: taskState.tasks.length,
                        itemBuilder: (context, index) {
                          final task = taskState.tasks[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: CommonCard(
                              title: task.title,
                              subtitle: task.category,
                              icon: Icons.delete,
                              ontap: () {
                                ref
                                    .read(taskProvider.notifier)
                                    .deleteTask(task.id!);
                                if (!context.mounted) return;
                                CustomSnackbar.show(
                                  context,
                                  message: "Task deleted Successfully",
                                  type: SnackbarType.success,
                                );
                              },
                              onPressed: () {
                                context.pushNamed(
                                  RouterConstants.taskdetailScreen,
                                  extra: task,
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
