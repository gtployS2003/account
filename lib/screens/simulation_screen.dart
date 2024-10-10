import 'package:account/models/renewable_energy.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SimulationScreen extends StatelessWidget {
  final RenewableEnergy energy;

  SimulationScreen({required this.energy});

  @override
  Widget build(BuildContext context) {
    double budgetPerSqM = 3000;
    double installationCost =
        calculateInstallationCost(energy.roofArea, budgetPerSqM);

    // คำนวณพลังงานจากแผงโซลาร์เซลล์
    double panelEfficiency = 0.18; // ประสิทธิภาพของแผงโซลาร์เซลล์ 18%
    double sunlightHoursPerDay =
        energy.sunlightHours; // จำนวนชั่วโมงแสงอาทิตย์ต่อวันจากข้อมูล
    double irradiance = 1.0; // ค่าความเข้มข้นของแสงอาทิตย์เป็น kW/m^2
    double energyProducedPerSqMPerDay =
        panelEfficiency * irradiance * sunlightHoursPerDay;
    double energyProducedPerSqMPerMonth =
        energyProducedPerSqMPerDay * 30; // เปลี่ยนจากวันเป็นเดือน
    double solarEnergyProduced = energy.roofArea *
        energyProducedPerSqMPerMonth; // พลังงานที่ผลิตได้จากขนาดหลังคา

    // คำนวณพลังงานจากกังหันลม (หากคำแนะนำเป็น Wind Energy)
    double windEnergyProduced = 0.0;
    if (energy.energyType.contains('Wind Energy')) {
      double radius = 5; // สมมติรัศมีใบพัดกังหันลมเป็น 5 เมตร
      double airDensity = 1.225; // ความหนาแน่นของอากาศ kg/m³
      double windTurbineEfficiency = 0.4; // ประสิทธิภาพของกังหันลม
      double sweptArea = pi * pow(radius, 2); // พื้นที่ใบพัดหมุน

      // คำนวณพลังงานที่ผลิตได้ต่อวันและต่อเดือนจากกังหันลม
      double power = 0.5 *
          airDensity *
          sweptArea *
          pow(energy.windSpeed, 3) *
          windTurbineEfficiency;
      windEnergyProduced = power *
          24 *
          30 /
          1000; // เปลี่ยนจาก kW เป็น kWh ต่อเดือน (24 ชั่วโมง * 30 วัน)
    }

    // สรุปพลังงานที่ผลิตได้ทั้งหมดขึ้นอยู่กับประเภทพลังงานที่แนะนำ
    double totalEnergyProduced = energy.energyType.contains('Wind Energy')
        ? windEnergyProduced
        : solarEnergyProduced;

    double monthlySavings =
        calculateMonthlySavings(energy.averageEnergyUsage, totalEnergyProduced);
    double paybackPeriod =
        calculatePaybackPeriod(installationCost, monthlySavings);

    return Scaffold(
      appBar: AppBar(
        title: const Text('การจำลองผลลัพธ์และคำนวณคืนทุน'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ข้อมูลบ้าน
            Text(
              'ข้อมูลบ้าน:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('- ขนาดบ้าน: ${energy.houseSize} ตร.ม.',
                style: TextStyle(fontSize: 18)),
            Text('- ขนาดหลังคา: ${energy.roofArea} ตร.ม.',
                style: TextStyle(fontSize: 18)),
            Text(
                '- การใช้พลังงานเฉลี่ยต่อเดือน: ${energy.averageEnergyUsage.toStringAsFixed(1)} kWh',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 16),

            // คำแนะนำพลังงาน
            Text('คำแนะนำพลังงาน:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('- ${energy.energyType}', style: TextStyle(fontSize: 18)),
            if (energy.energyType.contains('เพิ่มแผงโซลาร์เซลล์'))
              Text(
                  'แนะนำให้ติดตั้งแผงโซลาร์เซลล์เพิ่มเติมเพื่อรองรับการใช้พลังงานที่สูง',
                  style: TextStyle(fontSize: 18, color: Colors.blue)),
            if (energy.energyType.contains('เนื่องจากแสงแดดไม่เพียงพอ'))
              Text('แนะนำพลังงานลม เนื่องจากแสงแดดไม่เพียงพอ',
                  style: TextStyle(fontSize: 18, color: Colors.blue)),
            if (energy.energyType.contains('เพิ่มพื้นที่หลังคา'))
              Text('แนะนำให้พิจารณาเพิ่มพื้นที่หลังคาสำหรับแผงโซลาร์เซลล์',
                  style: TextStyle(fontSize: 18, color: Colors.blue)),
            SizedBox(height: 16),

            // ค่าใช้จ่ายและการประหยัด
            Text('ค่าใช้จ่ายและประหยัด:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(
                '- ค่าใช้จ่ายในการติดตั้ง: ${installationCost.toStringAsFixed(2)} บาท',
                style: TextStyle(fontSize: 18)),
            Text(
              '- ${monthlySavings > 0 ? 'ประหยัดพลังงานได้: ${monthlySavings.toStringAsFixed(2)} kWh ต่อเดือน' : 'การใช้พลังงานมากกว่าผลิตได้: ${(-monthlySavings).toStringAsFixed(2)} kWh ต่อเดือน'}',
              style: TextStyle(
                  fontSize: 18,
                  color: monthlySavings > 0 ? Colors.green : Colors.red),
            ),
            Text(
              paybackPeriod.isInfinite || paybackPeriod > 10
                  ? '- ไม่คุ้มค่าในการลงทุน ระยะเวลาคืนทุน: ${paybackPeriod.toStringAsFixed(1)} ปี'
                  : '- คุ้มค่าในการลงทุน ระยะเวลาคืนทุน: ${paybackPeriod.toStringAsFixed(1)} ปี',
              style: TextStyle(
                  fontSize: 18,
                  color: paybackPeriod.isInfinite || paybackPeriod > 10
                      ? Colors.red
                      : Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  double calculateInstallationCost(double roofArea, double budgetPerSqM) {
    return roofArea * budgetPerSqM;
  }

  double calculateMonthlySavings(
      double averageEnergyUsage, double energyProduced) {
    double savings = energyProduced - averageEnergyUsage;
    return savings > 0
        ? savings
        : -savings; // คืนค่าบวกหากมีการประหยัดและลบหากไม่พอ
  }

  double calculatePaybackPeriod(
      double installationCost, double monthlySavings) {
    if (monthlySavings <= 0) {
      return double.infinity; // แสดงว่าคืนทุนไม่ได้
    }
    return installationCost / (monthlySavings * 12);
  }
}
