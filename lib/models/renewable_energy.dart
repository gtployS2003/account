class RenewableEnergy {
  final int? keyID;               // Primary Key สำหรับจัดการข้อมูล
  final String energyType;         // ประเภทพลังงาน (โซลาร์เซลล์, กังหันลม ฯลฯ)
  final double installationArea;   // ขนาดพื้นที่ติดตั้ง (ตร.ม.)
  final double energyUsage;        // ปริมาณการใช้พลังงาน (kWh ต่อเดือน)
  final double installationCost;   // ต้นทุนการติดตั้ง (บาท)
  final double energySaving;       // การประหยัดพลังงาน (kWh ต่อปี)
  final double paybackPeriod;      // ระยะเวลาคืนทุน (ปี)

  RenewableEnergy({
    this.keyID,
    required this.energyType,
    required this.installationArea,
    required this.energyUsage,
    required this.installationCost,
    required this.energySaving,
    required this.paybackPeriod,
  });
  
  // ฟังก์ชันสำหรับแปลงข้อมูลเป็นแผนที่ (Map) เพื่อเก็บในฐานข้อมูล
  Map<String, dynamic> toMap() {
    return {
      'keyID': keyID,
      'energyType': energyType,
      'installationArea': installationArea,
      'energyUsage': energyUsage,
      'installationCost': installationCost,
      'energySaving': energySaving,
      'paybackPeriod': paybackPeriod,
    };
  }
}
