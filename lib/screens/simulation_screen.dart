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
    bool isBudgetSufficient = energy.installationBudget >= installationCost;

    double panelEfficiency = 0.18;
    double sunlightHoursPerDay = energy.sunlightHours;
    double irradiance = 1.0;
    double energyProducedPerSqMPerDay =
        panelEfficiency * irradiance * sunlightHoursPerDay;
    double energyProducedPerSqMPerMonth = energyProducedPerSqMPerDay * 30;
    double solarEnergyProduced = energy.roofArea * energyProducedPerSqMPerMonth;

    double windEnergyProduced = 0.0;
    if (energy.energyType.contains('Wind Energy')) {
      double radius = 5;
      double airDensity = 1.225;
      double windTurbineEfficiency = 0.4;
      double sweptArea = pi * pow(radius, 2);

      double power = 0.5 *
          airDensity *
          sweptArea *
          pow(energy.windSpeed, 3) *
          windTurbineEfficiency;
      windEnergyProduced = power * 24 * 30 / 1000;
    }

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildCardInfo(
                title: 'ข้อมูลบ้าน',
                rows: [
                  buildInfoRow('ขนาดบ้าน', '${energy.houseSize} ตร.ม.'),
                  buildInfoRow('ขนาดหลังคา', '${energy.roofArea} ตร.ม.'),
                  buildInfoRow('การใช้พลังงานเฉลี่ยต่อเดือน',
                      '${energy.averageEnergyUsage.toStringAsFixed(1)} kWh'),
                ],
              ),
              SizedBox(height: 16),
              buildCardInfo(
                title: 'คำแนะนำพลังงาน',
                rows: [
                  Text(
                    '- ${energy.energyType}',
                    style: TextStyle(fontSize: 18),
                  ),
                  if (energy.energyType.contains('เพิ่มแผงโซลาร์เซลล์'))
                    buildRecommendationText(
                        'แนะนำให้ติดตั้งแผงโซลาร์เซลล์เพิ่มเติมเพื่อรองรับการใช้พลังงานที่สูง'),
                  if (energy.energyType.contains('เนื่องจากแสงแดดไม่เพียงพอ'))
                    buildRecommendationText(
                        'แนะนำพลังงานลม เนื่องจากแสงแดดไม่เพียงพอ'),
                  if (energy.energyType.contains('เพิ่มพื้นที่หลังคา'))
                    buildRecommendationText(
                        'แนะนำให้พิจารณาเพิ่มพื้นที่หลังคาสำหรับแผงโซลาร์เซลล์'),
                ],
              ),
              SizedBox(height: 16),
              buildCardInfo(
                title: 'ค่าใช้จ่ายและการประหยัด',
                rows: [
                  buildInfoRow('ค่าใช้จ่ายในการติดตั้ง',
                      '${installationCost.toStringAsFixed(2)} บาท'),
                  buildInfoRow('งบประมาณที่มี',
                      '${energy.installationBudget.toStringAsFixed(2)} บาท'),
                  buildInfoRow(
                    'สถานะงบประมาณ',
                    isBudgetSufficient
                        ? 'เพียงพอสำหรับการติดตั้ง'
                        : 'ไม่เพียงพอสำหรับการติดตั้ง',
                    color: isBudgetSufficient ? Colors.green : Colors.red,
                  ),
                  buildInfoRow(
                    monthlySavings >= 0
                        ? 'ประหยัดพลังงานได้'
                        : ' ',
                    '${monthlySavings.abs().toStringAsFixed(2)} kWh ต่อเดือน',
                    color: monthlySavings >= 0 ? Colors.green : Colors.red,
                  ),
                  buildInfoRow(
                    paybackPeriod.isInfinite || paybackPeriod > 10
                        ? 'ไม่คุ้มค่าในการลงทุน'
                        : 'คุ้มค่าในการลงทุน',
                    'ระยะเวลาคืนทุน: ${paybackPeriod.toStringAsFixed(1)} ปี',
                    color: paybackPeriod.isInfinite || paybackPeriod > 10
                        ? Colors.red
                        : Colors.green,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCardInfo({required String title, required List<Widget> rows}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700]),
            ),
            SizedBox(height: 10),
            ...rows,
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(fontSize: 18, color: color ?? Colors.black),
          ),
        ],
      ),
    );
  }

  Widget buildRecommendationText(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, color: Colors.blue),
      ),
    );
  }

  double calculateInstallationCost(double roofArea, double budgetPerSqM) {
    return roofArea * budgetPerSqM;
  }

  double calculateMonthlySavings(
      double averageEnergyUsage, double energyProduced) {
    return energyProduced - averageEnergyUsage;
  }

  double calculatePaybackPeriod(
      double installationCost, double monthlySavings) {
    if (monthlySavings <= 0) {
      return double.infinity;
    }
    return installationCost / (monthlySavings * 12);
  }
}
