import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/core/utils/styles.dart';
import 'package:project/core/widgets/custom_text_field.dart';
import 'package:project/features/presentation/auth/cubits/auth_cubit/auth_cubit.dart';
import 'package:project/features/presentation/auth/cubits/auth_cubit/auth_states.dart';

import '../../../../../core/constants.dart';
import '../../../../../core/widgets/awesome_dialog.dart';
import '../../../../../core/widgets/custom_button.dart';
import '../../../../../core/widgets/logo.dart';
import '../../../../../core/widgets/show_snack.dart';
import '../../login/login_view.dart';

class SignUpViewBody extends StatefulWidget {
  const SignUpViewBody({super.key});

  @override
  State<SignUpViewBody> createState() => _LoginViewBodyState();
}

class _LoginViewBodyState extends State<SignUpViewBody> {
  TextEditingController emailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  AutovalidateMode autoValidateMode = AutovalidateMode.disabled;
  final GlobalKey<FormState> formKey = GlobalKey();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    userNameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          showAwesomeDialog(
              context: context,
              title: 'Email verification',
              description: 'please verify your email',
              dialogType: DialogType.info,
              btnOkOnPress: () {
                Navigator.pushReplacementNamed(context, LoginView.id,
                    arguments: [emailController.text, passwordController.text]);
              });
          isLoading = false;
        } else if (state is RegisterFailure) {
          showAwesomeDialog(context: context, description: state.error);
          autoValidateMode = AutovalidateMode.always;
          isLoading = false;
        } else {
          isLoading = true;
        }
      },
      builder: (context, state) => Form(
        key: formKey,
        autovalidateMode: autoValidateMode,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .05,
                ),
                const Center(child: Logo()),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Register',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 4,
                ),
                const Text(
                  'Enter your personal information',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  'UserName',
                  style: Styles.styleBold16(),
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextField(
                  textEditingController: userNameController,
                  hintText: 'Enter your name',
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
                Text(
                  'Confirm password',
                  style: Styles.styleBold16(),
                ),
                const SizedBox(
                  height: 8,
                ),
                CustomTextField(
                  suffixIcon: FontAwesomeIcons.eyeSlash,
                  textEditingController: confirmPasswordController,
                  hintText: 'Enter confirm password',
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomButton(
                  isLoading: isLoading,
                  label: 'SignUp',
                  on: () {
                    if (passwordController.text ==
                        confirmPasswordController.text) {
                      BlocProvider.of<AuthCubit>(context).registerUser(
                          email: emailController.text,
                          password: passwordController.text);
                    } else {
                      showAwesomeDialog(
                          context: context,
                          description: 'Password not matched');
                    }
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Already have an account?"),
                  const SizedBox(
                    width: 4,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, LoginView.id);
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Constants.mainColor),
                    ),
                  ),
                ])
              ],
            ),
          ),
        ),
      ),
    );
  }
}
