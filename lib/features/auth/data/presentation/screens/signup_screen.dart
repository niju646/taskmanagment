import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:interview/core/routes/router_constants.dart';
import 'package:interview/features/auth/auth_provider.dart';
import 'package:interview/features/tasks/data/widgets/common_button.dart';
import 'package:interview/features/tasks/data/widgets/common_text.dart';
import 'package:interview/features/tasks/data/widgets/common_text_field.dart';
import 'package:interview/features/tasks/data/widgets/custom_snack_bar.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 40),
                CommonText(text: "Signup", size: 30),
                SizedBox(height: 40),
                CommonText(text: "Enter email:"),
                SizedBox(height: 10),
                CommonTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    return null;
                  },
                  hintText: 'Email',
                  controller: emailController,
                ),
                SizedBox(height: 30),
                CommonText(text: "Enter password:"),
                SizedBox(height: 10),
                CommonTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    return null;
                  },
                  hintText: "Password",
                  controller: passwordController,
                ),

                SizedBox(height: 50),
                authState.isLoading
                    ? const CircularProgressIndicator()
                    : CommonButton(
                        title: "Sign up",
                        ontap: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          await ref
                              .read(authProvider.notifier)
                              .register(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim(),
                              );

                          final authState = ref.read(authProvider);
                          if (!context.mounted) return;
                          if (authState.user != null) {
                            context.goNamed(RouterConstants.taskscreen);
                            CustomSnackbar.show(
                              context,
                              message: "User created successfully",
                              type: SnackbarType.success,
                            );
                          } else if (authState.error != null) {
                            CustomSnackbar.show(
                              context,
                              message: "sign up failed",
                              type: SnackbarType.failure,
                            );
                          }
                          // context.pushNamed(RouterConstants.taskscreen);
                        },
                      ),

                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CommonText(text: "Are you aleardy a member?"),

                    TextButton(
                      onPressed: () {
                        context.pushNamed(RouterConstants.login);
                      },
                      child: CommonText(text: "login"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
