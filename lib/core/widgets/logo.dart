import 'package:flutter/material.dart';

import '../constants.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20, right: 14),
      decoration: const ShapeDecoration(
          color: Constants.secondaryColor, shape: CircleBorder()),
      child: Image.asset(
        'assets/images/logo.png',
        width: 50,
      ),
    );
  }
}
