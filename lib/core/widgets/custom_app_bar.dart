import 'package:flutter/material.dart';
import '../constants.dart';

AppBar customAppBar({required BuildContext context , required void Function() onPressed , String? title}) {
  return AppBar(
    centerTitle: true,
    title: Text(
      title ?? 'Homepage',
      style: const TextStyle(color: Constants.mainColor),
    ),
    backgroundColor: Colors.grey[100],
    elevation: 0,
    leading: IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.arrow_back_outlined)),
  );
}
