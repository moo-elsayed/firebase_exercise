import 'package:flutter/material.dart';

import '../../../../../core/constants.dart';

class ContinueWithGoogleButton extends StatelessWidget {
  const ContinueWithGoogleButton(
      {super.key,
      required this.on,
      this.isLoading = false,
      required this.label, this.indicatorColor});

  final String label;
  final void Function() on;
  final bool isLoading;
  final Color? indicatorColor;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        padding: const EdgeInsets.all(16),
        onPressed: on,
        minWidth: double.infinity,
        elevation: 0,
        color: Constants.secondaryColor,
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Constants.secondaryColor,
            )),
        child: isLoading
            ? SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: indicatorColor ?? Colors.white,
                ))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Image.asset(
                      'assets/images/google.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                  Text(
                    label,
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ));
  }
}
