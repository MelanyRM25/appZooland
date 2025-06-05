import 'package:flutter/material.dart';

class CampoTextoRedondeado extends StatelessWidget {
  final String hintText;
  final IconData icono;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final IconButton? suffixIcon;
  final String? Function(String?)? validator;  // <-- parámetro validator opcional

  const CampoTextoRedondeado({
    Key? key,
    required this.hintText,
    required this.icono,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.suffixIcon,
    this.validator,  // <-- agregar validator en constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Aquí puedes añadir decoración si quieres
      child: TextFormField(   // <-- Cambiado a TextFormField
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        cursorColor: const Color.fromARGB(255, 18, 173, 162),
        style: const TextStyle(color: Colors.black),
        validator: validator,  // <-- usar validator aquí
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icono, color: const Color.fromARGB(255, 18, 173, 162)),
          suffixIcon: suffixIcon,
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromARGB(255, 18, 173, 162), width: 1),
          ),
        ),
      ),
    );
  }
}
