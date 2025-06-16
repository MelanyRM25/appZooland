import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zooland/viewmodels/desparasitacion_viewmodel.dart';

class RegistroDesparasitacionPage extends StatelessWidget {
  final String idMascota;

  RegistroDesparasitacionPage({required this.idMascota});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DesparasitacionViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F6F9),
        appBar: AppBar(
          title: const Text('Registro de Desparasitación'),
          backgroundColor: const Color(0xFF4CB8AC),
          elevation: 0,
        ),
        body: Consumer<DesparasitacionViewModel>(
          builder: (context, vm, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Registra la desparasitación de la mascota',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 24),

                    _inputField(
                      icon: Icons.medical_services,
                      label: 'Producto desparasitante',
                      hint: 'Ej. Drontal Plus',
                      keyboardType: TextInputType.text,
                      onChanged: vm.setProducto,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Ingrese el producto' : null,
                    ),

                    _inputField(
                      icon: Icons.monitor_weight,
                      label: 'Peso (kg)',
                      hint: 'Ej. 3.5',
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onChanged: vm.setPeso,
                      validator: (v) => _validarNumero(v, 'peso'),
                    ),

                    _fechaField(
                      context: context,
                      icon: Icons.calendar_today,
                      label: 'Fecha de dosis',
                      fecha: vm.fechaDosis,
                      onSelected: vm.setFechaDosis,
                    ),

                    _fechaField(
                      context: context,
                      icon: Icons.event_repeat,
                      label: 'Próxima dosis',
                      fecha: vm.proximaDosis,
                      onSelected: vm.setProximaDosis,
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: vm.isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.save),
                        label: Text(vm.isLoading ? 'Guardando...' : 'Guardar'),
                        onPressed: vm.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  final exito =
                                      await vm.registrar(idMascota);
                                  if (exito) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Registro exitoso')),
                                    );
                                    Navigator.pop(context, true);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Error al guardar')),
                                    );
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CB8AC),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _inputField({
    required IconData icon,
    required String label,
    required String hint,
    required TextInputType keyboardType,
    required Function(String) onChanged,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.teal),
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _fechaField({
    required BuildContext context,
    required IconData icon,
    required String label,
    required DateTime? fecha,
    required Function(DateTime) onSelected,
  }) {
    final texto = fecha != null
        ? '${fecha.day.toString().padLeft(2, '0')}/${fecha.month.toString().padLeft(2, '0')}/${fecha.year}'
        : 'Seleccione una fecha';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: fecha ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
            locale: const Locale('es', 'ES'),
          );
          if (picked != null) {
            onSelected(picked);
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.teal),
            labelText: label,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          ),
          child: Text(
            texto,
            style: TextStyle(
              fontSize: 16,
              color: fecha != null ? Colors.black87 : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  String? _validarNumero(String? value, String campo) {
    if (value == null || value.isEmpty) return 'Ingrese $campo';
    final num? parsed = double.tryParse(value);
    if (parsed == null) return 'Ingrese un número válido';
    return null;
  }
}
