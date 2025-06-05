import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zooland/models/mascota_model.dart';
import 'package:zooland/viewmodels/propietario_viewmodel.dart';
import 'package:zooland/viewmodels/mascota_viewmodel.dart';

class RegistroPaciente extends StatefulWidget {
  const RegistroPaciente({Key? key}) : super(key: key);

  @override
  State<RegistroPaciente> createState() => _RegistroPacienteState();
}

class _RegistroPacienteState extends State<RegistroPaciente> {
  final _formKey = GlobalKey<FormState>();

  // Controladores propietario
  final nombrePropController = TextEditingController();
  final apellidoPatPropController = TextEditingController();
  final apellidoMatPropController = TextEditingController();
  final direccionPropController = TextEditingController();
  final celularPropController = TextEditingController();
  final referenciaPropController = TextEditingController();

  // Controladores mascota
  final nombreMascotaController = TextEditingController();
  final colorController = TextEditingController();

  String? especieSeleccionada;
  String? razaSeleccionada;
  String? sexoMascota;
  DateTime? fechaNacimientoMascota;
  File? imagenMascota;

  final List<String> especies = ['Perro', 'Gato'];
  final List<String> razasPerro = ['Labrador', 'Bulldog', 'Pastor Alemán'];
  final List<String> razasGato = ['Siames', 'Persa', 'Maine Coon'];
  final List<String> sexos = ['Macho', 'Hembra'];

  @override
  void dispose() {
    nombrePropController.dispose();
    apellidoPatPropController.dispose();
    apellidoMatPropController.dispose();
    direccionPropController.dispose();
    celularPropController.dispose();
    referenciaPropController.dispose();
    nombreMascotaController.dispose();
    colorController.dispose();
    super.dispose();
  }

  void _limpiarCampos() {
    _formKey.currentState?.reset();
    nombrePropController.clear();
    apellidoPatPropController.clear();
    apellidoMatPropController.clear();
    direccionPropController.clear();
    celularPropController.clear();
    referenciaPropController.clear();
    nombreMascotaController.clear();
    colorController.clear();
    setState(() {
      especieSeleccionada = null;
      razaSeleccionada = null;
      sexoMascota = null;
      fechaNacimientoMascota = null;
      imagenMascota = null;
    });
  }

  List<String> getRazasPorEspecie() {
    if (especieSeleccionada == 'Perro') return razasPerro;
    if (especieSeleccionada == 'Gato') return razasGato;
    return [];
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imagenMascota = File(pickedFile.path);
      });
    }
  }

  Future<void> _registrarPaciente() async {
    if (!_formKey.currentState!.validate()) return;

    if (fechaNacimientoMascota == null || sexoMascota == null || especieSeleccionada == null || razaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete todos los datos de la mascota.')),
      );
      return;
    }

    final propietarioVM = Provider.of<PropietarioViewModel>(context, listen: false);
    final mascotaVM = Provider.of<MascotaViewModel>(context, listen: false);

    final propietarioId = await propietarioVM.registrarPropietario(
      nombre: nombrePropController.text,
      apellidoPaterno: apellidoPatPropController.text,
      apellidoMaterno: apellidoMatPropController.text,
      direccion: direccionPropController.text,
      celular: celularPropController.text,
      numReferencia: referenciaPropController.text,
    );

    if (propietarioId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(propietarioVM.error ?? 'Error al registrar propietario')),
      );
      return;
    }

    final mascota = Mascota(
      idPropietario: propietarioId,
      nombre: nombreMascotaController.text,
      especie: especieSeleccionada!,
      raza: razaSeleccionada!,
      fechaNacimiento: fechaNacimientoMascota!,
      sexo: sexoMascota!,
      color: colorController.text,
      imagen_url: null,
    );

    try {
      await mascotaVM.registrarMascotaConImagen(
        mascota: mascota,
        imagen: imagenMascota!,
      );

      if (mascotaVM.error != null) {
        throw Exception(mascotaVM.error);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Paciente registrado con éxito!')),
      );
      _limpiarCampos();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final propietarioVM = context.watch<PropietarioViewModel>();
    final mascotaVM = context.watch<MascotaViewModel>();
    final cargando = propietarioVM.isLoading || mascotaVM.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Registro de Paciente')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const Text('Datos del Propietario', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(controller: nombrePropController, decoration: const InputDecoration(labelText: 'Nombre'), validator: _validarCampo),
                  TextFormField(controller: apellidoPatPropController, decoration: const InputDecoration(labelText: 'Apellido paterno'), validator: _validarCampo),
                  TextFormField(controller: apellidoMatPropController, decoration: const InputDecoration(labelText: 'Apellido materno'), validator: _validarCampo),
                  TextFormField(controller: direccionPropController, decoration: const InputDecoration(labelText: 'Dirección'), validator: _validarCampo),
                  TextFormField(controller: celularPropController, decoration: const InputDecoration(labelText: 'Celular'), keyboardType: TextInputType.phone, validator: _validarCampo),
                  TextFormField(controller: referenciaPropController, decoration: const InputDecoration(labelText: 'Referencia'), validator: _validarCampo),
                  const SizedBox(height: 20),
                  const Text('Datos de la Mascota', style: TextStyle(fontWeight: FontWeight.bold)),
                  TextFormField(controller: nombreMascotaController, decoration: const InputDecoration(labelText: 'Nombre de la mascota'), validator: _validarCampo),
                  DropdownButtonFormField<String>(
                    value: especieSeleccionada,
                    decoration: const InputDecoration(labelText: 'Especie'),
                    items: especies.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (value) => setState(() {
                      especieSeleccionada = value;
                      razaSeleccionada = null;
                    }),
                    validator: (value) => value == null ? 'Seleccione una especie' : null,
                  ),
                  DropdownButtonFormField<String>(
                    value: razaSeleccionada,
                    decoration: const InputDecoration(labelText: 'Raza'),
                    items: getRazasPorEspecie().map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (value) => setState(() => razaSeleccionada = value),
                    validator: (value) => value == null ? 'Seleccione una raza' : null,
                  ),
                  DropdownButtonFormField<String>(
                    value: sexoMascota,
                    decoration: const InputDecoration(labelText: 'Sexo'),
                    items: sexos.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (value) => setState(() => sexoMascota = value),
                    validator: (value) => value == null ? 'Seleccione el sexo' : null,
                  ),
                  TextFormField(controller: colorController, decoration: const InputDecoration(labelText: 'Color'), validator: _validarCampo),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(fechaNacimientoMascota == null
                            ? 'Fecha de nacimiento: no seleccionada'
                            : 'Fecha de nacimiento: ${fechaNacimientoMascota!.toLocal()}'.split(' ')[0]),
                      ),
                      TextButton(
                        onPressed: () async {
                          final fecha = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (fecha != null) {
                            setState(() => fechaNacimientoMascota = fecha);
                          }
                        },
                        child: const Text('Seleccionar'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  imagenMascota != null
                      ? Image.file(imagenMascota!, height: 150)
                      : const Text('No se ha seleccionado imagen'),
                  ElevatedButton(
                    onPressed: _seleccionarImagen,
                    child: const Text('Seleccionar imagen'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: cargando ? null : _registrarPaciente,
                    child: Text(cargando ? 'Registrando...' : 'Registrar'),
                  ),
                ],
              ),
            ),
          ),
          if (cargando)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  String? _validarCampo(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo es requerido';
    }
    return null;
  }
}
