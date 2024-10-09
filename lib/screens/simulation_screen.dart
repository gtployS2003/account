import 'package:account/models/renewable_energy.dart';
import 'package:flutter/material.dart';

class SimulationScreen extends StatelessWidget {
  final RenewableEnergy energy;

  SimulationScreen({required this.energy});

  @override
  Widget build(BuildContext context) {
    double budgetPerSqM = 5000;
    double installationCost = calculateInstallationCost(energy.roofArea, budgetPerSqM);
    double energyProduced = energy.roofArea * 10; // สมมติว่าแผงโซลาร์เซลล์ผลิต 10 kWh ต่อ ตร.ม.
    double monthlySavings = calculateMonthlySavings(energy.averageEnergyUsage, energyProduced);
    double paybackPeriod = calculatePaybackPeriod(installationCost, monthlySavings);

    // ตรวจสอบค่าเพื่อดูว่าถูกต้องหรือไม่
    print('Energy Produced: $energyProduced');
    print('Monthly Savings: $monthlySavings');
    print('Payback Period: $paybackPeriod');

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
            Text(
              '- ขนาดบ้าน: ${energy.houseSize} ตร.ม.',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '- ขนาดหลังคา: ${energy.roofArea} ตร.ม.',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '- การใช้พลังงานเฉลี่ยต่อเดือน: ${energy.averageEnergyUsage.toStringAsFixed(1)} kWh',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),

            // คำแนะนำพลังงาน
            Text(
              'คำแนะนำพลังงาน:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '- ${energy.energyType}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),

            // ค่าใช้จ่ายและการประหยัด
            Text(
              'ค่าใช้จ่ายและประหยัด:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              '- ค่าใช้จ่ายในการติดตั้ง: ${installationCost.toStringAsFixed(2)} บาท',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '- ${monthlySavings > 0 ? 'ประหยัดพลังงานได้: ${monthlySavings.toStringAsFixed(2)} kWh ต่อเดือน' : 'การใช้พลังงานมากกว่าผลิตได้: ${(-monthlySavings).toStringAsFixed(2)} kWh ต่อเดือน'}',
              style: TextStyle(
                fontSize: 18,
                color: monthlySavings > 0 ? Colors.green : Colors.red,
              ),
            ),
            Text(
              paybackPeriod.isInfinite || paybackPeriod < 0
                  ? '- ไม่คุ้มค่าในการลงทุน'
                  : '- คุ้มค่าในการลงทุน ระยะเวลาคืนทุน: ${paybackPeriod.toStringAsFixed(1)} ปี',
              style: TextStyle(
                fontSize: 18,
                color: paybackPeriod.isInfinite || paybackPeriod < 0 ? Colors.red : Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }

  double calculateInstallationCost(double roofArea, double budgetPerSqM) {
    return roofArea * budgetPerSqM;
  }

  double calculateMonthlySavings(double averageEnergyUsage, double energyProduced) {
    double savings = energyProduced - averageEnergyUsage;
    return savings > 0 ? savings : -savings; // คืนค่าบวกหากมีการประหยัดและลบหากไม่พอ
  }

  double calculatePaybackPeriod(double installationCost, double monthlySavings) {
    if (monthlySavings <= 0) {
      return double.infinity; // แสดงว่าคืนทุนไม่ได้
    }
    return installationCost / (monthlySavings * 12);
  }
}
