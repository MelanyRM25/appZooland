import 'package:flutter/material.dart';

class ContainerRedondeado extends StatelessWidget {
  final Widget? child;
  final Color color;
  final double alturaPorcentaje;

  const ContainerRedondeado({
    Key? key,
    this.child,
    this.color = Colors.white,
    this.alturaPorcentaje = 0.4, // Porcentaje de la altura total
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: size.width,
        height: size.height * alturaPorcentaje,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -4),
            )
          ],
        ),
        child: child ?? SizedBox.shrink(),
      ),
    );
  }
}
