import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zooland/viewmodels/datos_fisiologicos_viewmodel.dart';

class RegistroDatosFisiologicosPage extends StatelessWidget {
  final String idMascota;

  RegistroDatosFisiologicosPage({required this.idMascota});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DatosFisiologicosViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F6F9),
        appBar: AppBar(
          title: const Text('Datos Fisiológicos'),
          backgroundColor: const Color(0xFF4CB8AC),
          elevation: 0,
        ),
        body: Consumer<DatosFisiologicosViewModel>(
          builder: (context, vm, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Registra los signos vitales actuales de la mascota',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 24),

                    _inputField(
                      icon: Icons.monitor_weight,
                      label: 'Peso (kg)',
                      hint: 'Ej. 12.5',
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onChanged: vm.setPeso,
                      validator: (v) => _validarNumero(v, 'peso'),
                    ),

                    _inputField(
                      icon: Icons.thermostat,
                      label: 'Temperatura (°C)',
                      hint: 'Ej. 38.5',
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onChanged: vm.setTemperatura,
                      validator: (v) => _validarNumero(v, 'temperatura'),
                    ),

                    _inputField(
                      icon: Icons.favorite,
                      label: 'Frecuencia cardíaca (lpm)',
                      hint: 'Ej. 90',
                      keyboardType: TextInputType.number,
                      onChanged: vm.setFrecuenciaCardiaca,
                      validator: (v) => _validarNumeroEntero(v, 'frecuencia cardíaca'),
                    ),

                    _inputField(
                      icon: Icons.air,
                      label: 'Frecuencia respiratoria (rpm)',
                      hint: 'Ej. 25',
                      keyboardType: TextInputType.number,
                      onChanged: vm.setFrecuenciaRespiratoria,
                      validator: (v) => _validarNumeroEntero(v, 'frecuencia respiratoria'),
                    ),

                    _inputField(
                      icon: Icons.timer,
                      label: 'Tiempo de relleno capilar (s)',
                      hint: 'Ej. 1.5',
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onChanged: vm.setTiempoRellenoCapilar,
                      validator: (v) => _validarNumero(v, 'tiempo de relleno capilar'),
                    ),

                    const SizedBox(height: 30),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: vm.isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.save),
                        label: Text(vm.isLoading ? 'Guardando...' : 'Guardar'),
                        onPressed: vm.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  bool exito = await vm.registrarDatos(idMascota);
                                  if (exito) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Datos registrados con éxito')),
                                    );
                                    Navigator.pop(context, true);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Error al registrar datos')),
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  String? _validarNumero(String? value, String campo) {
    if (value == null || value.isEmpty) return 'Ingrese $campo';
    final num? parsed = double.tryParse(value);
    if (parsed == null) return 'Ingrese un número válido';
    return null;
  }

  String? _validarNumeroEntero(String? value, String campo) {
    if (value == null || value.isEmpty) return 'Ingrese $campo';
    final num? parsed = int.tryParse(value);
    if (parsed == null) return 'Ingrese un número válido';
    return null;
  }
}
