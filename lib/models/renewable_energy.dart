class RenewableEnergy {
  final int? keyID;               // Primary Key สำหรับจัดการข้อมูล
  final String energyType;         // ประเภทพลังงาน (โซลาร์เซลล์, กังหันลม ฯลฯ)
  final double houseSize;          // ขนาดบ้าน (ตร.ม.)
  final int numberOfResidents;     // จำนวนผู้อยู่อาศัย
  final double averageEnergyUsage; // การใช้ไฟฟ้าเฉลี่ยต่อเดือน (kWh)
  final String location;           // ตำแหน่งที่ตั้งของบ้าน
  final double roofArea;           // พื้นที่หลังคาสำหรับติดตั้งแผงโซลาร์เซลล์ (ตร.ม.)
  final String roofDirection;      // ทิศทางของหลังคา (เช่น เหนือ ใต้ ออก ตก)
  final String appliances;         // เครื่องใช้ไฟฟ้าที่ใช้บ่อย

  RenewableEnergy({
    this.keyID,
    required this.energyType,
    required this.houseSize,
    required this.numberOfResidents,
    required this.averageEnergyUsage,
    required this.location,
    required this.roofArea,
    required this.roofDirection,
    required this.appliances,
  });
  
  // ฟังก์ชันสำหรับแปลงข้อมูลเป็นแผนที่ (Map) เพื่อเก็บในฐานข้อมูล
  Map<String, dynamic> toMap() {
    return {
      'keyID': keyID,
      'energyType': energyType,
      'houseSize': houseSize,
      'numberOfResidents': numberOfResidents,
      'averageEnergyUsage': averageEnergyUsage,
      'location': location,
      'roofArea': roofArea,
      'roofDirection': roofDirection,
      'appliances': appliances,
    };
  }
}
