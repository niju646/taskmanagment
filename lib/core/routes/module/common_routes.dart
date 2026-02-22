import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:interview/core/routes/router_constants.dart';
import 'package:interview/features/auth/data/presentation/screens/login_screen.dart';
import 'package:interview/features/auth/data/presentation/screens/signup_screen.dart';
import 'package:interview/features/profile/presentation/profile_screen.dart';
import 'package:interview/features/tasks/data/model/task_models.dart';
import 'package:interview/features/tasks/data/presentation/splash_screen.dart';
import 'package:interview/features/tasks/data/presentation/task_details_screen.dart';
import 'package:interview/features/tasks/data/presentation/task_list_screen.dart';
import 'package:interview/features/tasks/data/presentation/task_screen.dart';

final List<GoRoute> commonRoutes = [
  GoRoute(
    path: '/',
    name: RouterConstants.splashscreen,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const SplashScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  ),
  GoRoute(
    path: '/signup',
    name: RouterConstants.signup,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const SignupScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  ),
  GoRoute(
    path: '/login',
    name: RouterConstants.login,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  ),
  GoRoute(
    path: '/homescreen',
    name: RouterConstants.taskscreen,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const TaskScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  ),

  GoRoute(
    path: '/profile',
    name: RouterConstants.profile,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const ProfileScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  ),

  GoRoute(
    path: '/fetchTasks',
    name: RouterConstants.fetchtasks,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const TaskListScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  ),

  GoRoute(
    path: '/taskdetailScreen',
    name: RouterConstants.taskdetailScreen,
    pageBuilder: (context, state) {
      final task = state.extra as Task;
      return CustomTransitionPage(
        key: state.pageKey,
        child: TaskDetailsScreen(task: task),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      );
    },
  ),
];
