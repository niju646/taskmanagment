import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:interview/core/routes/router_constants.dart';
import 'package:interview/features/auth/auth_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  // final StorageService _storageService = StorageService.instance;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _navigate();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
    );

    _animationController.forward();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    // final user = FirebaseAuth.instance.currentUser;
    final authState = ref.read(authProvider);

    if (authState.user != null) {
      context.goNamed(RouterConstants.taskscreen);
    } else {
      context.goNamed(RouterConstants.login);
    }

    // if (user != null) {
    //   context.goNamed(RouterConstants.taskscreen);
    // } else {
    //   context.goNamed(RouterConstants.login);
    // }

    // final token = await _storageService.getToken();

    // if (!mounted) return;

    // if (token != null && token.isNotEmpty) {
    //   context.pushReplacementNamed(RouterConstants.driverHomeScreen);
    // } else {
    //   context.pushReplacementNamed(RouterConstants.loginScreen);
    // }
    // context.pushReplacementNamed(RouterConstants.signup);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            Center(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value,
                    child: Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 100),
                          Center(
                            child: Icon(
                              Icons.task,
                              size: 64,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                            ),
                          ),

                          const SizedBox(height: 32),

                          Text(
                            'Task management',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color,
                            ),

                            // letterSpacing: 0.5,
                          ),

                          const SizedBox(height: 200),
                          SizedBox(
                            width: 250,
                            child: LinearProgressIndicator(
                              minHeight: 2,
                              color: Colors.black,
                              backgroundColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
