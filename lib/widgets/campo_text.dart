import 'package:flutter/material.dart';

class CampoTextoRedondeado extends StatelessWidget {
  final String hintText;
  final IconData icono;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final IconButton? suffixIcon;
  final String? Function(String?)? validator;

  const CampoTextoRedondeado({
    Key? key,
    required this.hintText,
    required this.icono,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.suffixIcon,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      cursorColor: Colors.teal,
      style: const TextStyle(color: Colors.black),
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icono, color: Colors.teal),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.teal, width: 1),
        ),
      ),
    );
  }
}
