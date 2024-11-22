import 'package:flutter/material.dart';
import 'package:project/features/presentation/auth/singup/widgets/signup_body.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});
  static String id = 'register';
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SignUpViewBody(),
      ),
    );
  }
}
