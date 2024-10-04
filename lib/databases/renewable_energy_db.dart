import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:account/models/renewable_energy.dart';  // ปรับเป็นโมเดล Renewable Energy

class RenewableEnergyDB {
  String dbName;

  RenewableEnergyDB({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDirectory.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  Future<int> insertDatabase(RenewableEnergy energy) async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store('energy');

    var keyID = store.add(db, {
      "energyType": energy.energyType,
      "installationArea": energy.installationArea,
      "energyUsage": energy.energyUsage,
      "installationCost": energy.installationCost,
      "energySaving": energy.energySaving,
      "paybackPeriod": energy.paybackPeriod,
    });
    db.close();
    return keyID;
  }

  Future<List<RenewableEnergy>> loadAllData() async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store('energy');
    var snapshot = await store.find(db, finder: Finder(sortOrders: [SortOrder(Field.key, false)]));
    List<RenewableEnergy> energies = [];
    for (var record in snapshot) {
      energies.add(RenewableEnergy(
        keyID: record.key,
        energyType: record['energyType'].toString(),
        installationArea: double.parse(record['installationArea'].toString()),
        energyUsage: double.parse(record['energyUsage'].toString()),
        installationCost: double.parse(record['installationCost'].toString()),
        energySaving: double.parse(record['energySaving'].toString()),
        paybackPeriod: double.parse(record['paybackPeriod'].toString()),
      ));
    }
    return energies;
  }

  deleteDatabase(int? index) async {
    var db = await this.openDatabase();
    var store = intMapStoreFactory.store('energy');
    await store.delete(db, finder: Finder(filter: Filter.equals(Field.key, index)));
  }
}
