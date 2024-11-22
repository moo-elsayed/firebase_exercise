import 'package:flutter/material.dart';
import 'package:project/features/presentation/auth/login/widgets/login_view_body.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static String id = 'login';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(child: LoginViewBody()),
    );
  }
}
