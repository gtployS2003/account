import 'package:account/provider/renewable_energy_provider.dart';
import 'package:account/screens/form_screen.dart';
import 'package:account/screens/simulation_screen.dart'; // นำเข้า SimulationScreen ที่เราสร้างไว้
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:account/screens/edit_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text("Renewable Energy App"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
      body: Consumer<RenewableEnergyProvider>(
        builder: (context, provider, Widget? child) {
          if (provider.energies.isEmpty) {
            print('No items available');
            return const Center(
              child: Text(
                'ไม่มีข้อมูลพลังงาน',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          } else {
            print('Items found: ${provider.energies.length}');
            return ListView.builder(
              itemCount: provider.energies.length,
              itemBuilder: (context, index) {
                var energy = provider.energies[index];
                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Text(
                      'ประเภทพลังงาน: ${energy.energyType}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow(
                              'ขนาดบ้าน', '${energy.houseSize} ตร.ม.'),
                          _buildDetailRow(
                              'ผู้อยู่อาศัย', '${energy.numberOfResidents} คน'),
                          _buildDetailRow('ใช้ไฟฟ้าเฉลี่ยต่อเดือน',
                              '${energy.averageEnergyUsage} kWh'),
                          _buildDetailRow('ที่ตั้ง', energy.location),
                          _buildDetailRow('พื้นที่ติดตั้งหลังคา',
                              '${energy.roofArea} ตร.ม.'),
                          _buildDetailRow('ทิศทางหลังคา', energy.roofDirection),
                          _buildDetailRow('เครื่องใช้ไฟฟ้า', energy.appliances),
                          _buildDetailRow(
                              'งบประมาณ', '${energy.installationBudget} บาท'),
                        ],
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      radius: 30,
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '${energy.houseSize} ตร.ม.',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditScreen(energy: energy),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            provider.deleteEnergy(energy.keyID);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SimulationScreen(energy: energy),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return FormScreen();
            },
          ));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
