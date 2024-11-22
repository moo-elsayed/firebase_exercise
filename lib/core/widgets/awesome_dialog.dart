import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

void showAwesomeDialog(
    {required BuildContext context,
    String? description,
    String title = 'Error',
    DialogType dialogType = DialogType.error,
    void Function()? btnOkOnPress,
    Color? btnOkColor,
    void Function()? cancelFun,
    String? cancelText,
    String? btnOkText,
    bool? dismissOnTouchOutside}) {
  AwesomeDialog(
    dismissOnTouchOutside: dismissOnTouchOutside ?? false,
    context: context,
    dialogType: dialogType,
    animType: AnimType.rightSlide,
    title: title,
    desc: description,
    btnOkText: btnOkText,
    btnOkOnPress: btnOkOnPress ?? () {},
    btnOkColor: btnOkColor ?? Colors.red,
    btnCancelColor: Colors.green,
    btnCancelOnPress: cancelFun,
    btnCancelText: cancelText,
  ).show();
}
