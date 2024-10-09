import 'package:account/models/renewable_energy.dart';
import 'package:flutter/material.dart';

class SimulationScreen extends StatelessWidget {
  final RenewableEnergy energy;

  SimulationScreen({required this.energy});

  @override
  Widget build(BuildContext context) {
    // จำลองผลลัพธ์และแสดงกราฟหรือข้อมูลที่คำนวณคืนทุน
    return Scaffold(
      appBar: AppBar(
        title: const Text('การจำลองผลลัพธ์และคำนวณคืนทุน'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'ประเภทพลังงาน: ${energy.energyType}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'ขนาดบ้าน: ${energy.houseSize} ตร.ม.',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'การใช้พลังงานเฉลี่ยต่อเดือน: ${energy.averageEnergyUsage} kWh',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // เพิ่มกราฟและข้อมูลการคำนวณคืนทุน
            Text(
              'การติดตั้งแผงโซลาร์เซลล์จะคืนทุนใน X ปี',
              style: TextStyle(fontSize: 18),
            ),
            // กราฟแสดงผลประหยัดค่าไฟ
            Text(
              'งบประมาณที่สามารถใช้ในการติดตั้ง: ${energy.installationBudget} บาท',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
