import 'package:account/models/renewable_energy.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/renewable_energy_provider.dart';

class EditScreen extends StatefulWidget {
  final RenewableEnergy energy;

  EditScreen({required this.energy});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController houseSizeController;
  late TextEditingController numberOfResidentsController;
  late TextEditingController averageEnergyUsageController;
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  late TextEditingController roofAreaController;
  late TextEditingController roofDirectionController;
  late TextEditingController appliancesController;
  late TextEditingController installationBudgetController;

  @override
  void initState() {
    super.initState();
    houseSizeController =
        TextEditingController(text: widget.energy.houseSize.toString());
    numberOfResidentsController =
        TextEditingController(text: widget.energy.numberOfResidents.toString());
    averageEnergyUsageController = TextEditingController(
        text: widget.energy.averageEnergyUsage.toString());
    latitudeController = TextEditingController(
        text: widget.energy.location.split(', ')[0].split(': ')[1]);
    longitudeController = TextEditingController(
        text: widget.energy.location.split(', ')[1].split(': ')[1]);
    roofAreaController =
        TextEditingController(text: widget.energy.roofArea.toString());
    roofDirectionController =
        TextEditingController(text: widget.energy.roofDirection);
    appliancesController =
        TextEditingController(text: widget.energy.appliances);
    installationBudgetController = TextEditingController(
        text: widget.energy.installationBudget.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Energy Data'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'ขนาดบ้าน (ตร.ม.)'),
                  keyboardType: TextInputType.number,
                  controller: houseSizeController,
                  validator: (String? input) {
                    if (input == null ||
                        input.isEmpty ||
                        double.tryParse(input) == null) {
                      return 'กรุณากรอกข้อมูลที่ถูกต้อง';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'จำนวนผู้อยู่อาศัย'),
                  keyboardType: TextInputType.number,
                  controller: numberOfResidentsController,
                  validator: (String? input) {
                    if (input == null ||
                        input.isEmpty ||
                        int.tryParse(input) == null) {
                      return 'กรุณากรอกข้อมูลที่ถูกต้อง';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'การใช้ไฟฟ้าเฉลี่ยต่อเดือน (kWh)',
                  ),
                  keyboardType: TextInputType.number,
                  controller: averageEnergyUsageController,
                ),
                // เพิ่มฟิลด์อื่นๆ เช่น latitude, longitude, roofArea, roofDirection ฯลฯ
                ElevatedButton(
                  child: const Text('Save Changes'),
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      var provider = Provider.of<RenewableEnergyProvider>(
                          context,
                          listen: false);

                      var updatedEnergy = RenewableEnergy(
                        keyID: widget.energy.keyID,
                        energyType: widget.energy.energyType,
                        houseSize: double.parse(houseSizeController.text),
                        numberOfResidents:
                            int.parse(numberOfResidentsController.text),
                        averageEnergyUsage:
                            double.parse(averageEnergyUsageController.text),
                        location:
                            'Lat: ${latitudeController.text}, Lon: ${longitudeController.text}',
                        roofArea: double.parse(roofAreaController.text),
                        roofDirection: roofDirectionController.text,
                        appliances: appliancesController.text,
                        installationBudget:
                            double.parse(installationBudgetController.text),
                        sunlightHours: widget.energy.sunlightHours,
                        windSpeed: widget.energy.windSpeed,
                      );

                      provider.updateEnergy(updatedEnergy);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
