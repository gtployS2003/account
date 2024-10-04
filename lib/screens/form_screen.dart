import 'package:account/main.dart';
import 'package:account/models/renewable_energy.dart';
import 'package:account/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/renewable_energy_provider.dart';  // เปลี่ยนเป็น renewable energy provider ถ้าจำเป็น

class FormScreen extends StatelessWidget {
  FormScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final energyTypeController = TextEditingController();
  final installationAreaController = TextEditingController();
  final energyUsageController = TextEditingController();
  final installationCostController = TextEditingController();
  final energySavingController = TextEditingController();
  final paybackPeriodController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แบบฟอร์มข้อมูลพลังงานหมุนเวียน'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'ประเภทพลังงาน (โซลาร์เซลล์, กังหันลม ฯลฯ)',
                ),
                autofocus: false,
                controller: energyTypeController,
                validator: (String? str) {
                  if (str!.isEmpty) {
                    return 'กรุณากรอกข้อมูล';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'ขนาดพื้นที่ติดตั้ง (ตร.ม.)',
                ),
                keyboardType: TextInputType.number,
                controller: installationAreaController,
                validator: (String? input) {
                  if (input == null || input.isEmpty || double.tryParse(input) == null || double.parse(input) < 0) {
                    return 'กรุณากรอกข้อมูลที่ถูกต้อง';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'ปริมาณการใช้พลังงาน (kWh ต่อเดือน)',
                ),
                keyboardType: TextInputType.number,
                controller: energyUsageController,
                validator: (String? input) {
                  if (input == null || input.isEmpty || double.tryParse(input) == null || double.parse(input) < 0) {
                    return 'กรุณากรอกข้อมูลที่ถูกต้อง';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'ต้นทุนการติดตั้ง (บาท)',
                ),
                keyboardType: TextInputType.number,
                controller: installationCostController,
                validator: (String? input) {
                  if (input == null || input.isEmpty || double.tryParse(input) == null || double.parse(input) < 0) {
                    return 'กรุณากรอกข้อมูลที่ถูกต้อง';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'การประหยัดพลังงาน (kWh ต่อปี)',
                ),
                keyboardType: TextInputType.number,
                controller: energySavingController,
                validator: (String? input) {
                  if (input == null || input.isEmpty || double.tryParse(input) == null || double.parse(input) < 0) {
                    return 'กรุณากรอกข้อมูลที่ถูกต้อง';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'ระยะเวลาคืนทุน (ปี)',
                ),
                keyboardType: TextInputType.number,
                controller: paybackPeriodController,
                validator: (String? input) {
                  if (input == null || input.isEmpty || double.tryParse(input) == null || double.parse(input) < 0) {
                    return 'กรุณากรอกข้อมูลที่ถูกต้อง';
                  }
                  return null;
                },
              ),
              TextButton(
                child: const Text('บันทึก'),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    // สร้างวัตถุ RenewableEnergy จากข้อมูลที่ผู้ใช้กรอก
                    var renewableEnergy = RenewableEnergy(
                      keyID: null,
                      energyType: energyTypeController.text,
                      installationArea: double.parse(installationAreaController.text),
                      energyUsage: double.parse(energyUsageController.text),
                      installationCost: double.parse(installationCostController.text),
                      energySaving: double.parse(energySavingController.text),
                      paybackPeriod: double.parse(paybackPeriodController.text),
                    );
                    
                    // เพิ่มข้อมูลไปที่ Provider
                    var provider = Provider.of<RenewableEnergyProvider>(context, listen: false);
                    provider.addEnergy(renewableEnergy);

                    // กลับไปยังหน้าแสดงผลหลัก
                    Navigator.push(context, MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) {
                        return MyHomePage();  // เปลี่ยนชื่อหน้าให้สอดคล้องกับโครงการของคุณ
                      },
                    ));
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
