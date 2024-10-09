import 'package:account/models/renewable_energy.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('การจำลองผลลัพธ์และคำนวณคืนทุน'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ประเภทพลังงาน: ${energy.energyType}', style: TextStyle(fontSize: 18)),
            Text('ขนาดบ้าน: ${energy.houseSize} ตร.ม.', style: TextStyle(fontSize: 18)),
            Text('การใช้พลังงานเฉลี่ยต่อเดือน: ${energy.averageEnergyUsage} kWh', style: TextStyle(fontSize: 18)),
            Text('ค่าใช้จ่ายในการติดตั้ง: ${installationCost.toStringAsFixed(2)} บาท', style: TextStyle(fontSize: 18)),
            Text('การประหยัดพลังงานต่อเดือน: ${monthlySavings.toStringAsFixed(2)} kWh', style: TextStyle(fontSize: 18)),
            Text('ระยะเวลาคืนทุน: ${paybackPeriod.toStringAsFixed(1)} ปี', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            LineChart(
              LineChartData(
                minX: 0,
                maxX: 60,
                minY: 0,
                maxY: monthlySavings * 60,
                lineBarsData: [
                  LineChartBarData(
                    spots: generateEnergySavingData(monthlySavings),
                    isCurved: true,
                    dotData: FlDotData(show: false),
                  ),
                ],
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
  double savings = averageEnergyUsage - energyProduced;
  if (savings.isNaN || savings.isInfinite) {
    return 0; // หรือกำหนดให้เป็นค่าอื่นๆ ที่เหมาะสม
  }
  return savings;
}

  double calculatePaybackPeriod(double installationCost, double monthlySavings) {
    return installationCost / (monthlySavings * 12);
  }

  List<FlSpot> generateEnergySavingData(double monthlySavings) {
    List<FlSpot> data = [];
    for (int month = 1; month <= 60; month++) {
      double savings = monthlySavings * month;
      data.add(FlSpot(month.toDouble(), savings));
    }
    return data;
  }
}
