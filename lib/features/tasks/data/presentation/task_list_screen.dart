import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:interview/core/routes/router_constants.dart';
import 'package:interview/features/auth/auth_provider.dart';
import 'package:interview/features/tasks/data/provider/task_provider.dart';
import 'package:interview/features/tasks/data/widgets/common_card.dart';
import 'package:interview/features/tasks/data/widgets/custom_snack_bar.dart';
import 'package:interview/features/tasks/data/widgets/empty_screen.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  final ScrollController _scrollController = ScrollController();

  Future<void> refreshData() async {
    await ref.read(taskProvider.notifier).fetchTasks(isLoadMore: false);
  }

  @override
  void initState() {
    super.initState();
    // Trigger initial fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(taskProvider.notifier).fetchTasks(isLoadMore: false);
      _scrollController.addListener(_scrollListener);
    });
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400) {
      ref.read(taskProvider.notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final taskState = ref.watch(taskProvider);

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final String displayName = user?.email?.split('@').first ?? 'User';
    final String avatarLetter = displayName.isNotEmpty
        ? displayName[0].toUpperCase()
        : '?';

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("My Tasks"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: colorScheme.surface,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () => context.pushNamed(RouterConstants.profile),
              icon: CircleAvatar(
                radius: 18,
                backgroundColor: colorScheme.primary.withAlpha(60),
                child: Text(
                  avatarLetter,
                  style: TextStyle(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: refreshData,
        color: colorScheme.primary,
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Greeting header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome back,",
                      style: textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayName,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onSurface,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            if (taskState.isLoading && taskState.tasks.isEmpty)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (taskState.tasks.isEmpty && taskState.error == null)
              SliverFillRemaining(
                hasScrollBody: false,
                child: emptyScreen(
                  message: "No tasks available\nPull down to refresh",
                ),
              )
            else ...[
              // Task list
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final task = taskState.tasks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: CommonCard(
                        title: task.title,
                        subtitle: task.category,
                        icon: Icons.delete_outline_rounded,
                        ontap: () {
                          ref.read(taskProvider.notifier).deleteTask(task.id!);
                          if (!context.mounted) return;
                          CustomSnackbar.show(
                            context,
                            message: "Task deleted successfully",
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
                  }, childCount: taskState.tasks.length),
                ),
              ),

              // Bottom loading indicator during pagination
              if (taskState.isFetchingMore)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ),

              // Error state
              if (taskState.error != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 48,
                          color: Colors.red.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Something went wrong",
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.error,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          taskState.error ?? "Unknown error",
                          textAlign: TextAlign.center,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton.icon(
                          onPressed: () =>
                              ref.read(taskProvider.notifier).fetchTasks(),
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text("Retry"),
                        ),
                      ],
                    ),
                  ),
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.pushNamed(RouterConstants.taskscreen),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        icon: const Icon(Icons.add_rounded),
        label: const Text("New Task"),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
