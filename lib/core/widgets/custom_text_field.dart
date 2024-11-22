import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/constants.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    this.hintText,
    this.onSaved,
    this.textEditingController,
    this.suffixIcon,
    this.autofocus = false,
  });

  final String? hintText;
  final void Function(String?)? onSaved;
  final TextEditingController? textEditingController;
  final IconData? suffixIcon;
  final bool? autofocus;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool icon = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: widget.autofocus ?? false,
      obscureText: widget.suffixIcon == null
          ? false
          : icon
              ? false
              : true,
      controller: widget.textEditingController,
      onSaved: widget.onSaved,
      validator: (val) {
        if (widget.hintText != 'Enter your name' && val!.isEmpty) {
          return 'field is required';
        }
        return null;
      },
      decoration: InputDecoration(
          suffixIcon: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  icon = !icon;
                  setState(() {});
                },
                child: FaIcon(
                  icon == false ? widget.suffixIcon : FontAwesomeIcons.eye,
                  size: 20,
                ),
              ),
            ],
          ),
          fillColor: Constants.secondaryColor,
          filled: true,
          hintText: widget.hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          border: myBorder(),
          enabledBorder: myBorder(),
          focusedBorder: myBorder(),
          errorBorder: myBorder(Colors.red),
          errorStyle: const TextStyle(color: Colors.red)),
    );
  }

  OutlineInputBorder myBorder([color]) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color ?? Constants.secondaryColor),
      borderRadius: const BorderRadius.all(Radius.circular(16)),
    );
  }
}
