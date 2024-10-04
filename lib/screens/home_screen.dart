import 'package:account/provider/renewable_energy_provider.dart';  // เปลี่ยนเป็น RenewableEnergyProvider
import 'package:account/screens/form_screen.dart';
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
        title: const Text("แอปพลังงานหมุนเวียน"),
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
            return const Center(
              child: Text('ไม่มีรายการ'),
            );
          } else {
            return ListView.builder(
              itemCount: provider.energies.length,
              itemBuilder: (context, index) {
                var energy = provider.energies[index];
                return Card(
                  elevation: 5,
                  margin:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                  child: ListTile(
                    title: Text('ประเภทพลังงาน: ${energy.energyType}'),
                    subtitle: Text(
                        'พื้นที่ติดตั้ง: ${energy.installationArea} ตร.ม.\n'
                        'การใช้พลังงาน: ${energy.energyUsage} kWh/เดือน\n'
                        'ต้นทุนการติดตั้ง: ${energy.installationCost} บาท\n'
                        'ประหยัดพลังงาน: ${energy.energySaving} kWh/ปี\n'
                        'ระยะเวลาคืนทุน: ${energy.paybackPeriod} ปี'),
                    leading: CircleAvatar(
                      radius: 30,
                      child: FittedBox(
                        child: Text('${energy.energySaving} kWh'),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        provider.deleteEnergy(energy.keyID);
                      },
                    ),
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
              return FormScreen();  // ไปที่หน้าฟอร์มเพื่อเพิ่มข้อมูล
            },
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
