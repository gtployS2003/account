import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:account/models/renewable_energy.dart';  // ปรับเป็นโมเดล Renewable Energy

class RenewableEnergyDB {
  String dbName;

  RenewableEnergyDB({required this.dbName});

  // ฟังก์ชันเปิดฐานข้อมูล
  Future<Database> openDatabase() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDirectory.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  // ฟังก์ชันเพิ่มข้อมูลพลังงานหมุนเวียนในฐานข้อมูล
  Future<int> insertDatabase(RenewableEnergy energy) async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store('energy');

    var keyID = store.add(db, {
      "energyType": energy.energyType,
      "houseSize": energy.houseSize,
      "numberOfResidents": energy.numberOfResidents,
      "averageEnergyUsage": energy.averageEnergyUsage,
      "location": energy.location,
      "roofArea": energy.roofArea,
      "roofDirection": energy.roofDirection,
      "appliances": energy.appliances,
    });
    db.close();
    return keyID;
  }

  // ฟังก์ชันโหลดข้อมูลพลังงานหมุนเวียนทั้งหมดจากฐานข้อมูล
  Future<List<RenewableEnergy>> loadAllData() async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store('energy');
    var snapshot = await store.find(db, finder: Finder(sortOrders: [SortOrder(Field.key, false)]));

    List<RenewableEnergy> energies = [];
    for (var record in snapshot) {
      energies.add(RenewableEnergy(
        keyID: record.key,
        energyType: record['energyType'].toString(),
        houseSize: double.parse(record['houseSize'].toString()),
        numberOfResidents: int.parse(record['numberOfResidents'].toString()),
        averageEnergyUsage: double.parse(record['averageEnergyUsage'].toString()),
        location: record['location'].toString(),
        roofArea: double.parse(record['roofArea'].toString()),
        roofDirection: record['roofDirection'].toString(),
        appliances: record['appliances'].toString(),
      ));
    }
    db.close();
    return energies;
  }

  // ฟังก์ชันลบข้อมูลพลังงานหมุนเวียน
  deleteDatabase(int? index) async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store('energy');
    await store.delete(db, finder: Finder(filter: Filter.equals(Field.key, index)));
    db.close();
  }
}
