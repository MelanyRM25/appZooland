import 'package:flutter/material.dart';
import 'package:zooland/models/mascota_model.dart';

class MascotaPage extends StatefulWidget {
  @override
  _MascotaPageState createState() => _MascotaPageState();
}

class _MascotaPageState extends State<MascotaPage> {
  late Mascota mascota;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Mascota) {
      mascota = args;
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 4,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      child: mascota.imagen_url != null && mascota.imagen_url!.isNotEmpty
                          ? Image.network(
                              mascota.imagen_url!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image_not_supported, size: 100),
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.pets, size: 100, color: Colors.grey),
                            ),
                    ),
                    Container(
                      color: Colors.black.withOpacity(0.3),
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
                            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${mascota.raza} • ${mascota.sexo} • 2.5y',
                            style: const TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: Column(
            children: [
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.medical_services),
                        label: const Text("Get care"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        ),
                      ),
                    ),
                    const TabBar(
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: "Overview"),
                        Tab(text: "History"),
                        Tab(text: "Health"),
                        Tab(text: "Records"),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildOverviewTab(),
                    const Center(child: Text("History")),
                    const Center(child: Text("Health")),
                    const Center(child: Text("Records")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Appointments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.brown[100],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: const [
                Icon(Icons.local_hospital, size: 40, color: Colors.brown),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Vet Appointment", style: TextStyle(fontWeight: FontWeight.bold)),
                      Text("Mon 24 Jan • Dr. Green"),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text("Preventive health care", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildHealthCard(Icons.medical_services, "Internal deworming", "22 Days left", Colors.green),
          _buildHealthCard(Icons.bug_report, "Flea medication", "6 Days left", Colors.orange),
        ],
      ),
    );
  }

  Widget _buildHealthCard(IconData icon, String title, String subtitle, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color)),
                Text(subtitle),
              ],
            ),
          )
        ],
      ),
    );
  }
}
