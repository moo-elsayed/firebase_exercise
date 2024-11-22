import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_states.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitial());

  Future<void> registerUser(
      {required String email, required String password}) async {
    if (email == '' || password == '') {
      emit(RegisterFailure(error: 'empty field!'));
    } else {
      emit(RegisterLoading());
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        FirebaseAuth.instance.currentUser!.sendEmailVerification();
        emit(RegisterSuccess());
      } on FirebaseAuthException catch (e) {
        late String message;
        if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          message = 'The account already exists for that email.';
        } else {
          message = e.code;
        }
        log(message);
        emit(RegisterFailure(error: message));
      } catch (e) {
        log(e.toString());
        emit(LoginFailure(error: e.toString()));
      }
    }
  }

  Future<void> loginUser(
      {required String email, required String password}) async {
    if (email == '' || password == '') {
      emit(LoginFailure(error: 'empty field!'));
    } else {
      emit(LoginLoading());
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        if (credential.user!.emailVerified) {
          emit(LoginSuccess());
        } else {
          FirebaseAuth.instance.currentUser!.sendEmailVerification();
          emit(VerifyEmail());
        }
      } on FirebaseAuthException catch (e) {
        late String message;
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided for that user.';
        } else {
          message = e.code;
        }
        log(message);
        emit(LoginFailure(error: message));
      }
    }
  }

  Future<void> signInWithGoogle({required BuildContext context}) async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    emit(GoogleLoading());

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    emit(GoogleSuccess());
  }
}
