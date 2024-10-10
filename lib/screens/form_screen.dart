import 'package:account/main.dart';
import 'package:account/models/renewable_energy.dart';
import 'package:account/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/renewable_energy_provider.dart';

class FormScreen extends StatelessWidget {
  FormScreen({super.key});

  final formKey = GlobalKey<FormState>();
  final houseSizeController = TextEditingController();
  final numberOfResidentsController = TextEditingController();
  final averageEnergyUsageController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final roofAreaController = TextEditingController();
  final roofDirectionController = TextEditingController();
  final appliancesController = TextEditingController();
  final installationBudgetController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('กรอกข้อมูลพลังงานหมุนเวียน'),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    var provider = Provider.of<RenewableEnergyProvider>(
                      context,
                      listen: false,
                    );

                    double lat = double.parse(latitudeController.text);
                    double lon = double.parse(longitudeController.text);
                    double roofArea = double.parse(roofAreaController.text);
                    String roofDirection = roofDirectionController.text;

                    var analysisResult = await provider.fetchAndAnalyzeData(
                      lat: lat,
                      lon: lon,
                      averageEnergyUsage:
                          double.parse(averageEnergyUsageController.text),
                      roofArea: roofArea,
                      roofDirection: roofDirection,
                    );

                    String recommendation = analysisResult['recommendation'];
                    double sunlightHours = analysisResult['sunlightHours'];
                    double windSpeed = analysisResult['windSpeed'];

                    var renewableEnergy = RenewableEnergy(
                      keyID: null,
                      energyType: recommendation,
                      houseSize: double.parse(houseSizeController.text),
                      numberOfResidents:
                          int.parse(numberOfResidentsController.text),
                      averageEnergyUsage:
                          double.parse(averageEnergyUsageController.text),
                      location:
                          'Lat: ${lat.toString()}, Lon: ${lon.toString()}',
                      roofArea: roofArea,
                      roofDirection: roofDirection,
                      appliances: appliancesController.text,
                      installationBudget:
                          double.parse(installationBudgetController.text),
                      sunlightHours: sunlightHours,
                      windSpeed: windSpeed,
                    );

                    provider.addEnergy(renewableEnergy);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (context) {
                          return MyHomePage();
                        },
                      ),
                    );
                  }
                },
                child: const Text('บันทึกข้อมูล'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 32.0,
                  ),
                ),
              ),
            ],
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            labelText: title,
            hintText: hintText,
            border: OutlineInputBorder(),
          ),
          validator: validator,
        ),
      ),
    );
  }

  String? _validateNumber(String? input) {
    if (input == null ||
        input.isEmpty ||
        double.tryParse(input) == null ||
        double.parse(input) < 0) {
      return 'กรุณากรอกข้อมูลที่ถูกต้อง';
    }
    return null;
  }

  String? _validateCoordinate(String? input) {
    if (input == null || input.isEmpty || double.tryParse(input) == null) {
      return 'กรุณากรอกค่าที่ถูกต้อง';
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
