import 'package:flutter/material.dart';

import '../constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.label,
      required this.on,
      this.isLoading = false, this.color});

  final String label;
  final void Function() on;
  final bool isLoading;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 0,
      padding: const EdgeInsets.all(16),
      onPressed: on,
      minWidth: double.infinity,
      color: color ?? Constants.mainColor,
      shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: color ?? Constants.mainColor)),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                color: Colors.white,
              ))
          : Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
    );
  }
}
