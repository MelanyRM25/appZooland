import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:zooland/models/mascota_model.dart';
import 'package:zooland/viewmodels/propietario_viewmodel.dart';
import 'package:zooland/viewmodels/mascota_viewmodel.dart';
import 'package:zooland/widgets/fondo.dart';
import 'package:zooland/widgets/boton_icono.dart';
import 'package:zooland/widgets/campo_text.dart';
import 'package:zooland/widgets/boton.dart';

class RegistroPaciente extends StatefulWidget {
  const RegistroPaciente({Key? key}) : super(key: key);

  @override
  State<RegistroPaciente> createState() => _RegistroPacienteState();
}

class _RegistroPacienteState extends State<RegistroPaciente> {
  final _formKey = GlobalKey<FormState>();

  // Propietario
  final nombrePropController = TextEditingController();
  final apellidoPatPropController = TextEditingController();
  final apellidoMatPropController = TextEditingController();
  final direccionPropController = TextEditingController();
  final celularPropController = TextEditingController();
  final referenciaPropController = TextEditingController();

  // Mascota
  final nombreMascotaController = TextEditingController();
  final colorController = TextEditingController();
  String? especieSeleccionada;
  String? razaSeleccionada;
  String? sexoMascota;
  DateTime? fechaNacimientoMascota;
  File? imagenMascota;

  final List<String> especies = ['Perro', 'Gato'];
  final List<String> razasPerro = [
  'Labrador',
  'Bulldog',
  'Pastor Alemán',
  'Pug',
  'Chihuahua',
  'Golden Retriever',
  'Boxer',
  'Mestizo',
  'Shih Tzu',
  'Beagle',
  'Dálmata',
];
final List<String> razasGato = [
  'Siames',
  'Persa',
  'Maine Coon',
  'Bengala',
  'Sphynx',
  'Exótico',
  'Ragdoll',
  'Mestizo',
  'British Shorthair',
];
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

  List<String> getRazasPorEspecie() {
    if (especieSeleccionada == 'Perro') return razasPerro;
    if (especieSeleccionada == 'Gato') return razasGato;
    return [];
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => imagenMascota = File(picked.path));
  }

  String? _validarRequerido(String? value) {
    if (value == null || value.trim().isEmpty) return 'Este campo es requerido';
    return null;
  }

  Future<void> _registrarPaciente() async {
    if (!_formKey.currentState!.validate() ||
        fechaNacimientoMascota == null ||
        sexoMascota == null ||
        especieSeleccionada == null ||
        razaSeleccionada == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete todos los campos')),
      );
      return;
    }

    final propVM = context.read<PropietarioViewModel>();
    final mascVM = context.read<MascotaViewModel>();

    final propietarioId = await propVM.registrarPropietario(
      nombre: nombrePropController.text.trim(),
      apellidoPaterno: apellidoPatPropController.text.trim(),
      apellidoMaterno: apellidoMatPropController.text.trim(),
      direccion: direccionPropController.text.trim(),
      celular: celularPropController.text.trim(),
      numReferencia: referenciaPropController.text.trim(),
    );

    if (propietarioId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(propVM.error ?? 'Error al registrar propietario')),
      );
      return;
    }

    final mascota = Mascota(
      idPropietario: propietarioId,
      nombre: nombreMascotaController.text.trim(),
      especie: especieSeleccionada!,
      raza: razaSeleccionada!,
      sexo: sexoMascota!,
      color: colorController.text.trim(),
      fechaNacimiento: fechaNacimientoMascota!,
      imagen_url: null,
    );

    await mascVM.registrarMascotaConImagen(
      mascota: mascota,
      imagen: imagenMascota!,
    );

    if (mascVM.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(mascVM.error!)),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Paciente registrado con éxito')),
    );

    _formKey.currentState!.reset();
    setState(() {
      especieSeleccionada = null;
      razaSeleccionada = null;
      sexoMascota = null;
      fechaNacimientoMascota = null;
      imagenMascota = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cargando = context.watch<PropietarioViewModel>().isLoading ||
        context.watch<MascotaViewModel>().isLoading;
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Fondo(
            coloresDegradado: const [
               Color.fromARGB(255, 73, 119, 219), // Teal oscuro
    Color.fromARGB(255, 64, 220, 238), // Teal más claro
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: w * 0.06, vertical: h * 0.02),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    BotonIcono(
                      onPressed: () => Navigator.pop(context),
                      icon: Icons.arrow_back,
                      iconColor: Colors.teal,
                      iconSize: 30,
                    ),
                    SizedBox(height: h * 0.015),
                    _buildSeccionConTitulo(
                      titulo: 'Datos del Propietario',
                      children: [
                        CampoTextoRedondeado(
                          hintText: 'Nombre',
                          icono: Icons.person_outline,
                          controller: nombrePropController,
                          validator: _validarRequerido,
                        ),
                        CampoTextoRedondeado(
                          hintText: 'Apellido paterno',
                          icono: Icons.person_outline,
                          controller: apellidoPatPropController,
                          validator: _validarRequerido,
                        ),
                        CampoTextoRedondeado(
                          hintText: 'Apellido materno',
                          icono: Icons.person_outline,
                          controller: apellidoMatPropController,
                          validator: _validarRequerido,
                        ),
                        CampoTextoRedondeado(
                          hintText: 'Dirección',
                          icono: Icons.home_outlined,
                          controller: direccionPropController,
                          validator: _validarRequerido,
                        ),
                        CampoTextoRedondeado(
                          hintText: 'Número de celular',
                          icono: Icons.phone_outlined,
                          controller: celularPropController,
                          keyboardType: TextInputType.phone,
                          validator: _validarRequerido,
                        ),
                        CampoTextoRedondeado(
                          hintText: 'Número de referencia',
                          icono: Icons.numbers,
                          controller: referenciaPropController,
                          keyboardType: TextInputType.number,
                          validator: _validarRequerido,
                        ),
                      ],
                    ),
                    _buildSeccionConTitulo(
                      titulo: 'Datos de la Mascota',
                      children: [
                        CampoTextoRedondeado(
                          hintText: 'Nombre mascota',
                          icono: Icons.pets_outlined,
                          controller: nombreMascotaController,
                          validator: _validarRequerido,
                        ),
                        _buildDropdown('Especie', especieSeleccionada, especies,
                            Icons.pets, (v) {
                          setState(() {
                            especieSeleccionada = v;
                            razaSeleccionada = null;
                          });
                        }),
                        _buildDropdown('Raza', razaSeleccionada, getRazasPorEspecie(),
                            Icons.pets, (v) {
                          setState(() => razaSeleccionada = v);
                        }),
                        _buildDropdown(
                            'Sexo', sexoMascota, sexos, Icons.pets_rounded, (v) {
                          setState(() => sexoMascota = v);
                        }),
                        CampoTextoRedondeado(
                          hintText: 'Color',
                          icono: Icons.format_paint_outlined,
                          controller: colorController,
                          validator: _validarRequerido,
                        ),
                        _buildFechaNacimiento(),
                        _buildSelectorImagen(),
                      ],
                    ),
                    SizedBox(height: h * 0.025),
                    cargando
                        ? const Center(child: CircularProgressIndicator())
                        : Center(
                            child: BotonWidget(
                              height: h * 0.07,
                              width: w * 0.6,
                              texto: 'Registrar Paciente',
                              coloresDegradado: const [
                                Color.fromARGB(255, 237, 129, 41),
                                Color.fromARGB(255, 227, 222, 74)
                              ],
                              onPressed: _registrarPaciente,
                            ),
                          ),
                    SizedBox(height: h * 0.04),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeccionConTitulo(
      {required String titulo, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF0E86E8),
            ),
          ),
          const SizedBox(height: 10),
          ...children.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: c,
              )),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hint, String? value, List<String> items, IconData icon,
      void Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.teal),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
      value: value,
      style: const TextStyle(color: Colors.black),
      iconEnabledColor: Colors.teal,
      dropdownColor: Colors.white,
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? 'Seleccione $hint' : null,
    );
  }

  Widget _buildFechaNacimiento() {
    return Row(
      children: [
        const Icon(Icons.calendar_today, color: Colors.teal),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            fechaNacimientoMascota == null
                ? 'Fecha de nacimiento'
                : 'Fecha: ${fechaNacimientoMascota!.toLocal().toString().split(' ')[0]}',
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () async {
            final f = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (f != null) setState(() => fechaNacimientoMascota = f);
          },
          child: const Text('Seleccionar'),
        ),
      ],
    );
  }

  Widget _buildSelectorImagen() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Foto de la mascota',
            style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black)),
        const SizedBox(height: 10),
        InkWell(
          onTap: _seleccionarImagen,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: imagenMascota != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(imagenMascota!, fit: BoxFit.cover),
                  )
                : const Center(
                    child: Icon(Icons.camera_alt_outlined,
                        size: 50, color: Colors.teal),
                  ),
          ),
        ),
      ],
    );
  }
}
