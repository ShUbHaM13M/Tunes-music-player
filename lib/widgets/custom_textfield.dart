import 'package:flutter/material.dart';
import 'package:tunes/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final bool autofocus;
  const CustomTextField({
    Key? key,
    required this.controller,
    this.placeholder = "",
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: autofocus,
      controller: controller,
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: TextStyle(
          color: textColor.withOpacity(0.4),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: textColor.withOpacity(0.4),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: textColor,
            width: 1,
          ),
        ),
      ),
      style: const TextStyle(
        color: textColor,
        fontSize: 18,
      ),
    );
  }
}
