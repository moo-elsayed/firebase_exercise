import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void showSnackBar2(BuildContext context, e) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(e.code),
    behavior: SnackBarBehavior.floating,
    width: 300,
  ));
}

void showSnackBar(BuildContext context, String mess) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(mess),
    behavior: SnackBarBehavior.floating,
    width: 300,
  ));
}