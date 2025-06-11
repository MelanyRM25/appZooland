import 'package:flutter/material.dart';
import 'package:zooland/models/mascota_model.dart';

class MascotaHeader extends StatelessWidget {
  final Mascota mascota;

  const MascotaHeader({super.key, required this.mascota});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          child: mascota.imagen_url != null && mascota.imagen_url!.isNotEmpty
              ? Image.network(
                  mascota.imagen_url!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 100),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                )
              : Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.pets, size: 100, color: Colors.grey),
                ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.6),
                Colors.transparent,
                Colors.transparent,
                Colors.black.withOpacity(0.6),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                mascota.nombre,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [Shadow(color: Colors.black54, offset: Offset(0, 1), blurRadius: 4)],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${mascota.raza} • ${mascota.sexo}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  shadows: [Shadow(color: Colors.black45, offset: Offset(0, 1), blurRadius: 3)],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
