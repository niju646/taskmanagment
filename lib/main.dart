import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:interview/core/routes/app_router.dart';
import 'package:interview/core/theme/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:interview/features/tasks/data/model/task_hive_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  // Hive.registerAdapter(TaskHiveModelAdapter());
  await Hive.openBox<TaskHiveModel>('tasksBox');
  await Hive.openBox('settings');
  await Firebase.initializeApp();
  runApp(ProviderScope(key: UniqueKey(), child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      routerConfig: appRouter,
    );
  }
}
