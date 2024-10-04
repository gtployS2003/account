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
            return const Center(
              child: Text('No items available'),
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
                    title: Text('Energy Type: ${energy.energyType}'),
                    subtitle: Text(
                        'Household Size: ${energy.houseSize} sq.m.\n'
                        'จำนวนผู้อยู่อาศัย: ${energy.numberOfResidents} people\n'
                        'Number of Occupants: ${energy.averageEnergyUsage} kWh\n'
                        'Location: ${energy.location}\n'
                        'Roof Area for Installation: ${energy.roofArea} sq.m.\n'
                        'Roof Direction: ${energy.roofDirection}\n'
                        'Frequently Used Appliances: ${energy.appliances}'),
                    leading: CircleAvatar(
                      radius: 30,
                      child: FittedBox(
                        child: Text('${energy.houseSize} sq.m.'),
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
