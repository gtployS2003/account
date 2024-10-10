import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:account/models/renewable_energy.dart'; // ปรับเป็นโมเดล Renewable Energy

class RenewableEnergyDB {
  String dbName;

  RenewableEnergyDB({required this.dbName});

  double parseDouble(dynamic value) {
    if (value == null) return 0.0;
    try {
      return double.parse(value.toString());
    } catch (e) {
      print('Failed to parse double: $value, using 0.0');
      return 0.0;
    }
  }
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
    "installationBudget": energy.installationBudget,
    "sunlightHours": energy.sunlightHours,
    "windSpeed": energy.windSpeed,
  });
  db.close();
  return keyID;
}

  // ฟังก์ชันโหลดข้อมูลพลังงานหมุนเวียนทั้งหมดจากฐานข้อมูล
  Future<List<RenewableEnergy>> loadAllData() async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store('energy');
    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder(Field.key, false)]));

    List<RenewableEnergy> energies = [];
    for (var record in snapshot) {
      print('Loaded record: $record');
      energies.add(RenewableEnergy(
        keyID: record.key,
        energyType: record['energyType'].toString(),
        houseSize: parseDouble(record['houseSize']),
        numberOfResidents: int.parse(record['numberOfResidents'].toString()),
        averageEnergyUsage: parseDouble(record['averageEnergyUsage']),
        location: record['location'].toString(),
        roofArea: parseDouble(record['roofArea']),
        roofDirection: record['roofDirection'].toString(),
        appliances: record['appliances'].toString(),
        installationBudget: parseDouble(record['installationBudget']),
        sunlightHours: parseDouble(record['sunlightHours']),
        windSpeed: parseDouble(record['windSpeed']),
      ));
    }
    db.close();
    return energies;
  }

  // ฟังก์ชันลบข้อมูลพลังงานหมุนเวียน
  deleteDatabase(int? index) async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store('energy');
    await store.delete(db,
        finder: Finder(filter: Filter.equals(Field.key, index)));
    db.close();
  }
}
