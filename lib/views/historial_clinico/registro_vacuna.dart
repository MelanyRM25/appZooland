import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:zooland/viewmodels/vacuna_viewmodel.dart';

class RegistroVacunaPage extends StatelessWidget {
  final String idMascota;
  RegistroVacunaPage({required this.idMascota});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VacunaViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Registrar Vacuna'),
          backgroundColor: const Color(0xFF4CB8AC),
        ),
        body: Consumer<VacunaViewModel>(
          builder: (context, vm, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _inputField(
                      label: 'Nombre de la Vacuna',
                      hint: 'Ej. Rabia',
                      onChanged: vm.setNombreVacuna,
                      validator: (v) => v == null || v.isEmpty ? 'Ingrese el nombre de la vacuna' : null,
                    ),
                    const SizedBox(height: 16),
                    _datePickerField(
                      label: 'Fecha de Aplicación',
                      selectedDate: vm.fechaAplicacion,
                      onDateSelected: vm.setFechaAplicacion,
                    ),
                    const SizedBox(height: 16),
                    _datePickerField(
                      label: 'Fecha Próxima Dosis',
                      selectedDate: vm.fechaProximaDosis,
                      onDateSelected: vm.setFechaProximaDosis,
                    ),
                    const SizedBox(height: 16),
                    _inputField(
                      label: 'Peso de la Mascota (kg)',
                      hint: 'Ej. 12.5',
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      onChanged: vm.setPesoMascota,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Ingrese el peso';
                        if (double.tryParse(v) == null) return 'Ingrese un número válido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: vm.isLoading
                            ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Icon(Icons.save),
                        label: Text(vm.isLoading ? 'Guardando...' : 'Guardar'),
                        onPressed: vm.isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  bool exito = await vm.registrarVacuna(idMascota);
                                  if (exito) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Vacuna registrada con éxito')),
                                    );
                                    Navigator.pop(context, true);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Error al registrar vacuna')),
                                    );
                                  }
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CB8AC),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          textStyle: TextStyle(fontSize: 16),
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
    required String hint,
    Function(String)? onChanged,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
      ),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget _datePickerField({
    required String label,
    required DateTime? selectedDate,
    required Function(DateTime) onDateSelected,
  }) {
    final text = selectedDate == null ? 'Seleccione una fecha' : DateFormat('dd/MM/yyyy').format(selectedDate);
    return InkWell(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: _formKey.currentContext!,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          filled: true,
          fillColor: Colors.white,
        ),
        child: Text(text, style: TextStyle(fontSize: 16)),
      ),
    );
  }
}
