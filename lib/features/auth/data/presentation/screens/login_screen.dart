import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:interview/core/routes/router_constants.dart';
import 'package:interview/features/auth/auth_provider.dart';
import 'package:interview/features/tasks/data/widgets/common_button.dart';
import 'package:interview/features/tasks/data/widgets/common_text.dart';
import 'package:interview/features/tasks/data/widgets/common_text_field.dart';
import 'package:interview/features/tasks/data/widgets/custom_snack_bar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                CommonText(text: "Login", size: 30),
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
                      return "password is required";
                    }
                    return null;
                  },
                  hintText: "Password",
                  controller: passwordController,
                ),

                SizedBox(height: 50),
                CommonButton(
                  title: "login",
                  ontap: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }
                    await ref
                        .read(authProvider.notifier)
                        .login(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                    final state = ref.read(authProvider);
                    if (!context.mounted) return;
                    if (state.user != null) {
                      context.pushNamed(RouterConstants.fetchtasks);
                      CustomSnackbar.show(
                        context,
                        message: "Login successfull",
                        type: SnackbarType.success,
                      );
                    } else if (state.error != null) {
                      CustomSnackbar.show(
                        context,
                        message: "Login failed",
                        type: SnackbarType.failure,
                      );
                    }
                    // context.pushNamed(RouterConstants.taskscreen);
                  },
                ),

                SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonText(text: "Dont have an account?"),

                    TextButton(
                      onPressed: () async {
                        context.pushNamed(RouterConstants.signup);
                      },
                      child: CommonText(text: "signup"),
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
