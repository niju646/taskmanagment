import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:interview/features/auth/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:interview/core/routes/router_constants.dart';
import 'package:interview/features/tasks/data/provider/task_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile"), centerTitle: true),
      body: user == null
          ? const Center(child: Text("No user found"))
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  /// Avatar
                  CircleAvatar(
                    radius: 50,
                    child: Text(
                      user.email != null ? user.email![0].toUpperCase() : "U",
                      style: const TextStyle(fontSize: 32),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Email
                  Text(
                    user.email ?? "No Email",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const SizedBox(height: 40),

                  /// Logout Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () async {
                      await ref.read(authProvider.notifier).logout();
                      ref.invalidate(taskProvider);

                      if (!context.mounted) return;

                      context.goNamed(RouterConstants.login);
                    },
                    child: const Text("Logout"),
                  ),
                ],
              ),
            ),
    );
  }
}
