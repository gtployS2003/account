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
  final latitudeController = TextEditingController(); // เพิ่มตัวควบคุมละติจูด
  final longitudeController = TextEditingController(); // เพิ่มตัวควบคุมลองจิจูด
  final roofAreaController = TextEditingController();
  final roofDirectionController = TextEditingController();
  final appliancesController = TextEditingController();
  final installationBudgetController = TextEditingController();

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
                  labelText: 'ขนาดบ้าน (ตร.ม.)',
                ),
                keyboardType: TextInputType.number,
                controller: houseSizeController,
                validator: (String? input) {
                  if (input == null ||
                      input.isEmpty ||
                      double.tryParse(input) == null ||
                      double.parse(input) < 0) {
                    return 'กรุณากรอกข้อมูลที่ถูกต้อง';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'จำนวนผู้อยู่อาศัย',
                ),
                keyboardType: TextInputType.number,
                controller: numberOfResidentsController,
                validator: (String? input) {
                  if (input == null ||
                      input.isEmpty ||
                      int.tryParse(input) == null ||
                      int.parse(input) <= 0) {
                    return 'กรุณากรอกจำนวนที่ถูกต้อง';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'การใช้ไฟฟ้าเฉลี่ยต่อเดือน (kWh)',
                ),
                keyboardType: TextInputType.number,
                controller: averageEnergyUsageController,
                validator: (String? input) {
                  if (input == null ||
                      input.isEmpty ||
                      double.tryParse(input) == null ||
                      double.parse(input) < 0) {
                    return 'กรุณากรอกข้อมูลที่ถูกต้อง';
                  }
                  return null;
                },
              ),
// ฟิลด์สำหรับกรอกละติจูด
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'ละติจูด (Lat)',
                ),
                keyboardType: TextInputType.number,
                controller: latitudeController,
                validator: (String? input) {
                  if (input == null ||
                      input.isEmpty ||
                      double.tryParse(input) == null) {
                    return 'กรุณากรอกละติจูดที่ถูกต้อง';
                  }
                  return null;
                },
              ),
// ฟิลด์สำหรับกรอกลองจิจูด
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'ลองจิจูด (Lon)',
                ),
                keyboardType: TextInputType.number,
                controller: longitudeController,
                validator: (String? input) {
                  if (input == null ||
                      input.isEmpty ||
                      double.tryParse(input) == null) {
                    return 'กรุณากรอกลองจิจูดที่ถูกต้อง';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'พื้นที่หลังคาสำหรับติดตั้งแผงโซลาร์เซลล์ (ตร.ม.)',
                ),
                keyboardType: TextInputType.number,
                controller: roofAreaController,
                validator: (String? input) {
                  if (input == null ||
                      input.isEmpty ||
                      double.tryParse(input) == null ||
                      double.parse(input) < 0) {
                    return 'กรุณากรอกข้อมูลที่ถูกต้อง';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'ทิศทางของหลังคา (เช่น เหนือ ใต้ ออก ตก)',
                ),
                keyboardType: TextInputType.text,
                controller: roofDirectionController,
                validator: (String? input) {
                  if (input == null || input.isEmpty) {
                    return 'กรุณากรอกทิศทางของหลังคา';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'เครื่องใช้ไฟฟ้าที่ใช้บ่อย',
                ),
                keyboardType: TextInputType.text,
                controller: appliancesController,
                validator: (String? input) {
                  if (input == null || input.isEmpty) {
                    return 'กรุณากรอกข้อมูลเครื่องใช้ไฟฟ้า';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'งบประมาณที่สามารถใช้ในการติดตั้ง (บาท)',
                ),
                keyboardType: TextInputType.number,
                controller: installationBudgetController,
                validator: (String? input) {
                  if (input == null ||
                      input.isEmpty ||
                      double.tryParse(input) == null ||
                      double.parse(input) <= 0) {
                    return 'กรุณากรอกงบประมาณที่ถูกต้อง';
                  }
                  return null;
                },
              ),

              TextButton(
                child: const Text('Save'),
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    var provider = Provider.of<RenewableEnergyProvider>(context,
                        listen: false);
                    double lat = double.parse(latitudeController.text);
                    double lon = double.parse(longitudeController.text);

                    // เรียกใช้ฟังก์ชันและใช้ค่าที่ได้
                    String recommendation =
                        await provider.fetchAndAnalyzeData(lat, lon);

                    // สร้างวัตถุ RenewableEnergy จากข้อมูลที่ผู้ใช้กรอกและคำแนะนำ
                    var renewableEnergy = RenewableEnergy(
                      keyID: null,
                      energyType: recommendation,
                      houseSize: double.parse(houseSizeController.text),
                      numberOfResidents:
                          int.parse(numberOfResidentsController.text),
                      averageEnergyUsage:
                          double.parse(averageEnergyUsageController.text),
                      location:
                          'Lat: ${latitudeController.text}, Lon: ${longitudeController.text}',
                      roofArea: double.parse(roofAreaController.text),
                      roofDirection: roofDirectionController.text,
                      appliances: appliancesController.text,
                      installationBudget: double.parse(
                          installationBudgetController
                              .text), // เพิ่มงบประมาณที่ผู้ใช้กรอก
                    );

                    provider.addEnergy(renewableEnergy);

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
