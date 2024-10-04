import 'package:account/main.dart';
import 'package:account/models/renewable_energy.dart';
import 'package:account/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/renewable_energy_provider.dart';

class FormScreen extends StatelessWidget {
  FormScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final houseSizeController = TextEditingController();
  final numberOfResidentsController = TextEditingController();
  final averageEnergyUsageController = TextEditingController();
  final latitudeController = TextEditingController();  // เพิ่มตัวควบคุมละติจูด
  final longitudeController = TextEditingController(); // เพิ่มตัวควบคุมลองจิจูด
  final roofAreaController = TextEditingController();
  final roofDirectionController = TextEditingController();
  final appliancesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Renewable Energy Data Form'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'House Size (sq.m.)',
                ),
                keyboardType: TextInputType.number,
                controller: houseSizeController,
                validator: (String? input) {
                  if (input == null || input.isEmpty || double.tryParse(input) == null || double.parse(input) < 0) {
                    return 'Please enter valid information';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Number of Occupants',
                ),
                keyboardType: TextInputType.number,
                controller: numberOfResidentsController,
                validator: (String? input) {
                  if (input == null || input.isEmpty || int.tryParse(input) == null || int.parse(input) <= 0) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Average Monthly Electricity Usage (kWh)',
                ),
                keyboardType: TextInputType.number,
                controller: averageEnergyUsageController,
                validator: (String? input) {
                  if (input == null || input.isEmpty || double.tryParse(input) == null || double.parse(input) < 0) {
                    return 'Please enter valid information';
                  }
                  return null;
                },
              ),
              // ฟิลด์สำหรับกรอกละติจูด
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Latitude (Lat)',
                ),
                keyboardType: TextInputType.number,
                controller: latitudeController,
                validator: (String? input) {
                  if (input == null || input.isEmpty || double.tryParse(input) == null) {
                    return 'Please enter a valid latitude';
                  }
                  return null;
                },
              ),
              // ฟิลด์สำหรับกรอกลองจิจูด
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Longitude (Lon)',
                ),
                keyboardType: TextInputType.number,
                controller: longitudeController,
                validator: (String? input) {
                  if (input == null || input.isEmpty || double.tryParse(input) == null) {
                    return 'Please enter a valid longitude';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Roof Area for Solar Panel Installation (sq.m.)',
                ),
                keyboardType: TextInputType.number,
                controller: roofAreaController,
                validator: (String? input) {
                  if (input == null || input.isEmpty || double.tryParse(input) == null || double.parse(input) < 0) {
                    return 'Please enter valid information';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Roof Direction (e.g., North, South, East, West)',
                ),
                keyboardType: TextInputType.text,
                controller: roofDirectionController,
                validator: (String? input) {
                  if (input == null || input.isEmpty) {
                    return 'Please enter the roof direction';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Frequently Used Appliances',
                ),
                keyboardType: TextInputType.text,
                controller: appliancesController,
                validator: (String? input) {
                  if (input == null || input.isEmpty) {
                    return 'Please enter the appliance information';
                  }
                  return null;
                },
              ),
              TextButton(
                child: const Text('Save'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // สร้างวัตถุ RenewableEnergy จากข้อมูลที่ผู้ใช้กรอก
                    var renewableEnergy = RenewableEnergy(
                      keyID: null,
                      energyType: 'Renewable Energy',
                      houseSize: double.parse(houseSizeController.text),
                      numberOfResidents: int.parse(numberOfResidentsController.text),
                      averageEnergyUsage: double.parse(averageEnergyUsageController.text),
                      location: 'Lat: ${latitudeController.text}, Lon: ${longitudeController.text}', // เก็บข้อมูลละติจูดและลองจิจูดในฟิลด์ location
                      roofArea: double.parse(roofAreaController.text),
                      roofDirection: roofDirectionController.text,
                      appliances: appliancesController.text,
                    );

                    // เพิ่มข้อมูลไปที่ Provider
                    var provider = Provider.of<RenewableEnergyProvider>(context, listen: false);
                    provider.addEnergy(renewableEnergy);

                    // กลับไปยังหน้าแสดงผลหลัก
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) {
                          return MyHomePage(); // กลับไปยังหน้า Home
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
