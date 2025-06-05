import 'package:flutter/material.dart';

class DropdownRedondeado<T> extends StatelessWidget {
  final String hintText;
  final IconData icono;
  final T? value;  // cambiado de valorSeleccionado a value
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const DropdownRedondeado({
    Key? key,
    required this.hintText,
    required this.icono,
    required this.items,
    required this.onChanged,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color.fromARGB(255, 255, 255, 255)),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,
          iconEnabledColor: const Color.fromARGB(255, 18, 173, 162),
          dropdownColor: Colors.white,
          style: const TextStyle(color: Colors.black,fontSize: 16),
          hint: Row(
            children: [
              Icon(icono, color: const Color.fromARGB(255, 18, 173, 162)),
              const SizedBox(width: 12),
              Text(
                hintText,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          selectedItemBuilder: (BuildContext context) {
            return items.map<Widget>((DropdownMenuItem<T> item) {
              return Row(
                children: [
                  Icon(icono, color: const Color.fromARGB(255, 18, 173, 162)),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      item.child is Text ? (item.child as Text).data ?? '' : '',
                      style: const TextStyle(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
    );
  }
}
