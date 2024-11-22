import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/features/presentation/auth/cubits/auth_cubit/auth_cubit.dart';
import 'package:project/features/presentation/auth/login/login_view.dart';

import 'package:project/simple_bloc_observer.dart';
import 'features/presentation/auth/singup/signup_view.dart';

import 'features/presentation/home_view/cubits/category_cubit/category_cubit.dart';
import 'features/presentation/home_view/home_view.dart';
import 'features/presentation/wrestlers_view/Wrestler_view.dart';
import 'features/presentation/wrestlers_view/cubits/wrestler_cubit/wrestler_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        log('User is currently signed out!');
      } else {
        log('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CategoryCubit(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        BlocProvider(
          create: (context) => WrestlerCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: (FirebaseAuth.instance.currentUser == null ||
                !FirebaseAuth.instance.currentUser!.emailVerified)
            ? const LoginView()
            : const HomeView(),
        routes: {
          SignUpView.id: (context) => const SignUpView(),
          LoginView.id: (context) => const LoginView(),
          HomeView.id: (context) => const HomeView(),
          WrestlerView.id: (context) => const WrestlerView(),
        },
      ),
    );
  }
}
