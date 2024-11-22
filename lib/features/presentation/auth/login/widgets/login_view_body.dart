import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project/core/utils/styles.dart';
import 'package:project/core/widgets/custom_text_field.dart';
import 'package:project/features/presentation/auth/cubits/auth_cubit/auth_cubit.dart';
import 'package:project/features/presentation/auth/cubits/auth_cubit/auth_states.dart';

import '../../../../../core/constants.dart';
import '../../../../../core/widgets/awesome_dialog.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/logo.dart';

import '../../../../../core/widgets/show_snack.dart';

import '../../../home_view/cubits/category_cubit/category_cubit.dart';
import '../../../home_view/home_view.dart';
import '../../singup/signup_view.dart';
import 'sign_in_with_google_button.dart';

class LoginViewBody extends StatefulWidget {
  const LoginViewBody({super.key});

  @override
  State<LoginViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<LoginViewBody> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;
  bool googleLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as List<String>?;
    if (arguments != null && arguments.isNotEmpty) {
      emailController.text = arguments[0];
      passwordController.text = arguments[1];
    }
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          Navigator.pushReplacementNamed(context, HomeView.id);
          BlocProvider.of<CategoryCubit>(context).getCategories();
          isLoading = false;
        } else if (state is LoginFailure) {
          showAwesomeDialog(context: context, description: state.error);
          autoValidateMode = AutovalidateMode.always;
          isLoading = false;
          setState(() {});
        } else if (state is LoginLoading) {
          isLoading = true;
        } else if (state is GoogleLoading) {
          googleLoading = true;
        } else if (state is GoogleSuccess) {
          Navigator.of(context).pushReplacementNamed(HomeView.id);
          BlocProvider.of<CategoryCubit>(context).getCategories();
          googleLoading = false;
        } else {
          showAwesomeDialog(
              context: context,
              title: 'Email verification',
              description: 'please verify your email',
              dialogType: DialogType.info);
          //isLoading = false;
        }
      },
      builder: (context, state) => Form(
        autovalidateMode: autoValidateMode,
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .1,
                ),
                const Center(child: Logo()),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Login',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Login to continue using the app',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Email',
                  style: Styles.styleBold16(),
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextField(
                  textEditingController: emailController,
                  hintText: 'Enter your email',
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'Password',
                  style: Styles.styleBold16(),
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextField(
                  suffixIcon: FontAwesomeIcons.eyeSlash,
                  textEditingController: passwordController,
                  hintText: 'Enter your password',
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  GestureDetector(
                    onTap: () async {
                      if (emailController.text.isNotEmpty) {
                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: emailController.text);
                          showAwesomeDialog(
                              context: context,
                              description:
                                  'an email has been sent to your email address',
                              dialogType: DialogType.info,
                              title: 'Reset password');
                        } catch (e) {
                          log(e.toString());
                        }
                      } else {
                        showAwesomeDialog(
                          context: context,
                          description: 'write your email first!',
                          dialogType: DialogType.warning,
                        );
                      }
                    },
                    child: const Text(
                      'Forget password?',
                    ),
                  ),
                ]),
                const SizedBox(
                  height: 16,
                ),
                CustomButton(
                  isLoading: isLoading,
                  label: 'Login',
                  on: () {
                    BlocProvider.of<AuthCubit>(context).loginUser(
                        email: emailController.text,
                        password: passwordController.text);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                ContinueWithGoogleButton(
                  indicatorColor: Constants.mainColor,
                  isLoading: googleLoading,
                  label: 'Login with google',
                  on: () {
                    BlocProvider.of<AuthCubit>(context)
                        .signInWithGoogle(context: context);
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Don't have an account?"),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, SignUpView.id);
                    },
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Constants.mainColor),
                    ),
                  )
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
