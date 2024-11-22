import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:project/core/widgets/custom_app_bar.dart';
import 'package:project/features/presentation/home_view/widgets/custom_home_floating_action_button.dart';
import 'package:project/features/presentation/home_view/widgets/home_view_body.dart';




import '../auth/login/login_view.dart';
import 'cubits/category_cubit/category_cubit.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static String id = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: const CustomHomeFloatingActionButton(),
      appBar: customAppBar(
          context: context,
          onPressed: () async {
            GoogleSignIn googleSignIn = GoogleSignIn();
            await googleSignIn.signOut();
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacementNamed(context, LoginView.id);
            BlocProvider.of<CategoryCubit>(context).categoryList = [];
          }),
      body: const HomeViewBody(),
    );
  }
}
