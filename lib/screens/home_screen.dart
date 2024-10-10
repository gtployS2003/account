import 'package:account/provider/renewable_energy_provider.dart';
import 'package:account/screens/form_screen.dart';
import 'package:account/screens/simulation_screen.dart'; // นำเข้า SimulationScreen ที่เราสร้างไว้
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
          // ตรวจสอบว่ามีรายการพลังงานหมุนเวียนหรือไม่
          if (provider.energies.isEmpty) {
            print('No items available');
            return const Center(
              child: Text('No items available'),
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
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: ListTile(
                    title: Text('Energy Type: ${energy.energyType}'),
                    subtitle: Text(
                      'ขนาดบ้าน: ${energy.houseSize} ตร.ม.\n'
                      'จำนวนผู้อยู่อาศัย: ${energy.numberOfResidents} คน\n'
                      'การใช้ไฟฟ้าเฉลี่ยต่อเดือน: ${energy.averageEnergyUsage} kWh\n'
                      'ตำแหน่งที่ตั้ง: ${energy.location}\n'
                      'พื้นที่หลังคาสำหรับติดตั้ง: ${energy.roofArea} ตร.ม.\n'
                      'ทิศทางของหลังคา: ${energy.roofDirection}\n'
                      'เครื่องใช้ไฟฟ้าที่ใช้บ่อย: ${energy.appliances}\n'
                      'งบประมาณที่ใช้ในการติดตั้ง: ${energy.installationBudget} บาท', // แสดงงบประมาณ
                    ),
                    leading: CircleAvatar(
                      radius: 30,
                      child: FittedBox(
                        child: Text('${energy.houseSize} ตร.ม.'),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        provider.deleteEnergy(energy.keyID);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SimulationScreen(energy: energy),
                          ));
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return FormScreen(); // ไปที่หน้าฟอร์มเพื่อเพิ่มข้อมูล
            },
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
