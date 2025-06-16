import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zooland/viewmodels/anamnesis_viewmodel.dart';

class RegistroAnamnesisPage extends StatelessWidget {
  final String idMascota;

  RegistroAnamnesisPage({required this.idMascota});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AnamnesisViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F6F9),
        appBar: AppBar(
          title: const Text('Registrar Anamnesis'),
          backgroundColor: const Color(0xFF4CB8AC),
          elevation: 0,
        ),
        body: Consumer<AnamnesisViewModel>(
          builder: (context, vm, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _inputField(
                      label: 'Síntomas',
                      maxLines: 3,
                      icon: Icons.medical_services,
                      onChanged: vm.setSintomas,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Ingrese los síntomas' : null,
                    ),
                    _inputField(
                      label: 'Intervenciones Previas (opcional)',
                      maxLines: 3,
                      icon: Icons.healing,
                      onChanged: vm.setIntervencionesPrevias,
                    ),
                    _inputField(
                      label: 'Enfermedades Previas (opcional)',
                      maxLines: 3,
                      icon: Icons.report_problem,
                      onChanged: vm.setEnfermedadesPrevias,
                    ),
                    _inputField(
                      label: 'Pre Diagnóstico (opcional)',
                      maxLines: 3,
                      icon: Icons.assignment,
                      onChanged: vm.setPreDiagnostico,
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
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Icon(Icons.save),
                        label: Text(vm.isLoading ? 'Guardando...' : 'Guardar'),
                        onPressed: vm.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  bool exito = await vm.registrarAnamnesis(idMascota);
                                  if (exito) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content:
                                              Text('Anamnesis registrada con éxito')),
                                    );
                                    Navigator.pop(context, true);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Error al registrar anamnesis')),
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
    required String label,
    required Function(String) onChanged,
    String? Function(String?)? validator,
    int maxLines = 1,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF4CB8AC)) : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
        ),
        maxLines: maxLines,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}
