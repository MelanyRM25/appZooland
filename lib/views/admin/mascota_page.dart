import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zooland/models/mascota_model.dart';
import 'package:zooland/models/propietario_model.dart';
import 'package:zooland/viewmodels/propietario_viewmodel.dart';
import 'package:zooland/widgets/anamnesis_tab.dart';
import 'package:zooland/widgets/datos_fisiologicos_tab.dart';
import 'package:zooland/widgets/descripcion_general_tab.dart';
import 'package:zooland/widgets/desparasitaciones_tab.dart';
import 'package:zooland/widgets/mascota_header.dart';
import 'package:zooland/widgets/tarjeta_qr_widget.dart';
import 'package:zooland/widgets/vacuna_tab.dart';

class MascotaPage extends StatefulWidget {
  const MascotaPage({Key? key}) : super(key: key);

  @override
  _MascotaPageState createState() => _MascotaPageState();
}

class _MascotaPageState extends State<MascotaPage> {
  late Mascota mascota;
  Propietario? propietario;
  final GlobalKey _qrCardKey = GlobalKey();
  bool _isLoadingPropietario = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Mascota) {
      mascota = args;
      _cargarPropietario();
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _cargarPropietario() async {
    setState(() {
      _isLoadingPropietario = true;
    });

    final propietarioVM = Provider.of<PropietarioViewModel>(
      context,
      listen: false,
    );
    final resultado = await propietarioVM.obtenerPropietarioPorId(
      mascota.idPropietario,
    );

    setState(() {
      propietario = resultado;
      _isLoadingPropietario = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 6,
        child: NestedScrollView(
          headerSliverBuilder:
              (context, _) => [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: MascotaHeader(mascota: mascota),
                  ),
                ),
              ],
          body: Column(
            children: [
              Container(
                color: Colors.white,
                child: const TabBar(
                  labelColor: Colors.blue,
                  unselectedLabelColor: Colors.grey,
                  isScrollable: true,
                  tabs: [
                    Tab(text: "Descripción General"),
                    Tab(text: "Anamnesis"),
                    Tab(text: "Vacunas"),
                    Tab(text: "Desparasitaciones"),
                    Tab(text: "Datos Fisiológicos"),
                    Tab(text: "Tarjeta QR"),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _isLoadingPropietario || propietario == null
                        ? const Center(child: CircularProgressIndicator())
                        : DescripcionGeneralTab(
                          mascota: mascota,
                          propietario: propietario!,
                        ),
                    AnamnesisTab(mascota: mascota),
                    VacunasTab(mascota: mascota),
                    DesparasitacionesTab(mascota: mascota,),
                    DatosFisiologicosTab(mascota: mascota),
                    TarjetaQRWidget(qrCardKey: _qrCardKey, mascota: mascota),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
