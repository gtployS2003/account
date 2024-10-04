import 'package:account/databases/renewable_energy_db.dart';
import 'package:flutter/foundation.dart';
import 'package:account/models/renewable_energy.dart';

class RenewableEnergyProvider with ChangeNotifier {
  List<RenewableEnergy> energies = [];   // เปลี่ยนจาก transactions เป็น energies

  // ฟังก์ชันสำหรับดึงข้อมูลพลังงานหมุนเวียนทั้งหมด
  List<RenewableEnergy> getEnergies() {
    return energies;
  }

  // ฟังก์ชันสำหรับโหลดข้อมูลเริ่มต้นจากฐานข้อมูล
  void initData() async {
    var db = RenewableEnergyDB(dbName: 'renewable_energy.db');  // ใช้ชื่อฐานข้อมูลใหม่
    this.energies = await db.loadAllData();
    print(this.energies);
    notifyListeners();
  }

  // ฟังก์ชันสำหรับเพิ่มข้อมูลพลังงานหมุนเวียนใหม่
  void addEnergy(RenewableEnergy energy) async {
    var db = RenewableEnergyDB(dbName: 'renewable_energy.db');
    var keyID = await db.insertDatabase(energy);
    // ตรวจสอบว่ามีการเพิ่มสำเร็จหรือไม่
    if (keyID != null) {
      this.energies = await db.loadAllData();
      print(this.energies);
      notifyListeners();  // แจ้งเตือนผู้ฟัง (listeners) เพื่อให้ UI อัปเดต
    }
  }

  // ฟังก์ชันสำหรับลบข้อมูลพลังงานหมุนเวียน
  void deleteEnergy(int? index) async {
    print('delete index: $index');
    var db = RenewableEnergyDB(dbName: 'renewable_energy.db');
    await db.deleteDatabase(index);
    this.energies = await db.loadAllData();
    notifyListeners();  // แจ้งเตือนผู้ฟังเพื่อให้ UI อัปเดตหลังจากลบข้อมูล
  }
}
