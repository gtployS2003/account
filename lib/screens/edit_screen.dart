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
                _buildInputCard(
                  context,
                  title: 'ขนาดบ้าน (ตร.ม.)',
                  controller: houseSizeController,
                  keyboardType: TextInputType.number,
                  hintText: 'กรอกขนาดบ้าน',
                  validator: _validateNumber,
                ),
                _buildInputCard(
                  context,
                  title: 'จำนวนผู้อยู่อาศัย',
                  controller: numberOfResidentsController,
                  keyboardType: TextInputType.number,
                  hintText: 'กรอกจำนวนผู้อยู่อาศัย',
                  validator: _validateNumber,
                ),
                _buildInputCard(
                  context,
                  title: 'การใช้ไฟฟ้าเฉลี่ยต่อเดือน (kWh)',
                  controller: averageEnergyUsageController,
                  keyboardType: TextInputType.number,
                  hintText: 'กรอกค่าไฟฟ้าเฉลี่ยต่อเดือน',
                  validator: _validateNumber,
                ),
                _buildInputCard(
                  context,
                  title: 'ละติจูด (Lat)',
                  controller: latitudeController,
                  keyboardType: TextInputType.number,
                  hintText: 'กรอกละติจูด',
                  validator: _validateCoordinate,
                ),
                _buildInputCard(
                  context,
                  title: 'ลองจิจูด (Lon)',
                  controller: longitudeController,
                  keyboardType: TextInputType.number,
                  hintText: 'กรอกลองจิจูด',
                  validator: _validateCoordinate,
                ),
                _buildInputCard(
                  context,
                  title: 'พื้นที่หลังคาสำหรับติดตั้ง (ตร.ม.)',
                  controller: roofAreaController,
                  keyboardType: TextInputType.number,
                  hintText: 'กรอกพื้นที่หลังคา',
                  validator: _validateNumber,
                ),
                _buildInputCard(
                  context,
                  title: 'ทิศทางของหลังคา',
                  controller: roofDirectionController,
                  keyboardType: TextInputType.text,
                  hintText: 'เช่น เหนือ ใต้ ออก ตก',
                  validator: _validateText,
                ),
                _buildInputCard(
                  context,
                  title: 'เครื่องใช้ไฟฟ้าที่ใช้บ่อย',
                  controller: appliancesController,
                  keyboardType: TextInputType.text,
                  hintText: 'เช่น แอร์, ทีวี, ตู้เย็น',
                  validator: _validateText,
                ),
                _buildInputCard(
                  context,
                  title: 'งบประมาณในการติดตั้ง (บาท)',
                  controller: installationBudgetController,
                  keyboardType: TextInputType.number,
                  hintText: 'กรอกงบประมาณ',
                  validator: _validateNumber,
                ),
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

  Widget _buildInputCard(
    BuildContext context, {
    required String title,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String hintText,
    required String? Function(String?) validator,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                hintText: hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              validator: validator,
            ),
          ],
        ),
      ),
    );
  }

  String? _validateNumber(String? input) {
    if (input == null || input.isEmpty || double.tryParse(input) == null) {
      return 'กรุณากรอกข้อมูลที่ถูกต้อง';
    }
    return null;
  }

  String? _validateCoordinate(String? input) {
    if (input == null || input.isEmpty || double.tryParse(input) == null) {
      return 'กรุณากรอกละติจูด/ลองจิจูดที่ถูกต้อง';
    }
    return null;
  }

  String? _validateText(String? input) {
    if (input == null || input.isEmpty) {
      return 'กรุณากรอกข้อมูล';
    }
    return null;
  }
}
