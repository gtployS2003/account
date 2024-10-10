import 'package:account/databases/renewable_energy_db.dart';
import 'package:flutter/foundation.dart';
import 'package:account/models/renewable_energy.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RenewableEnergyProvider with ChangeNotifier {
  List<RenewableEnergy> energies = [];
  double _sunlightHours = 0.0; // เพิ่มฟิลด์นี้
  double _windSpeed = 0.0; // เพิ่มฟิลด์นี้

  // สร้าง getter สำหรับ sunlightHours และ windSpeed
  double get sunlightHours => _sunlightHours;
  double get windSpeed => _windSpeed;

  // ฟังก์ชันคำนวณชั่วโมงแสงอาทิตย์จากค่าของ sunrise และ sunset
  double calculateSunlightHours(int sunrise, int sunset) {
    return (sunset - sunrise) / 3600;
  }

  // ฟังก์ชันสำหรับดึงข้อมูลพลังงานหมุนเวียนทั้งหมด
  List<RenewableEnergy> getEnergies() {
    return energies;
  }

  // ฟังก์ชันสำหรับโหลดข้อมูลเริ่มต้นจากฐานข้อมูล
  void initData() async {
    var db = RenewableEnergyDB(dbName: 'renewable_energy.db');
    this.energies = await db.loadAllData();
    notifyListeners();
  }

  // ฟังก์ชันสำหรับเพิ่มข้อมูลพลังงานหมุนเวียนใหม่
  void addEnergy(RenewableEnergy energy) async {
    var db = RenewableEnergyDB(dbName: 'renewable_energy.db');
    var keyID = await db.insertDatabase(energy);
    if (keyID != null) {
      this.energies = await db.loadAllData();
      notifyListeners(); // ตรวจสอบว่า notifyListeners() ถูกเรียกใช้หลังจากโหลดข้อมูล
    }
  }

  // ฟังก์ชันสำหรับดึงข้อมูลสภาพอากาศจาก API
  Future<Map<String, dynamic>> fetchWeatherData(double lat, double lon) async {
    final apiKey = 'f14cd842fcff44e359e0d20dc5ccf46f';
    final url =
        'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&exclude=minutely,hourly&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print(
          'Weather data: ${response.body}'); // เพิ่มบรรทัดนี้เพื่อตรวจสอบข้อมูลที่ได้รับ
      return json.decode(response.body);
    } else {
      print('Failed to load weather data: ${response.statusCode}');
      throw Exception('Failed to load weather data');
    }
  }

  // ฟังก์ชันวิเคราะห์ข้อมูลบ้านเพื่อแนะนำพลังงานหมุนเวียนที่เหมาะสม
  Future<String> analyzeAndRecommendEnergy({
    required double sunlightHours,
    required double windSpeed,
    required double averageEnergyUsage,
    required double roofArea,
    required String roofDirection,
  }) async {
    String recommendation;

    // วิเคราะห์ข้อมูลสภาพอากาศและบ้าน
    if (sunlightHours > 5 &&
        roofArea >= 20 &&
        (roofDirection == 'ใต้' ||
            roofDirection == 'ตะวันตกเฉียงใต้' ||
            roofDirection == 'ตะวันออกเฉียงใต้')) {
      recommendation = 'แนะนำพลังงานแสงอาทิตย์ (Solar Energy)';
      if (averageEnergyUsage > 500) {
        recommendation +=
            ' และเพิ่มแผงโซลาร์เซลล์เพื่อรองรับการใช้พลังงานที่สูง';
      }
    } else if (windSpeed > 10 && roofArea >= 15) {
      recommendation = 'แนะนำพลังงานลม (Wind Energy)';
      if (sunlightHours < 4) {
        recommendation += ' เนื่องจากแสงแดดไม่เพียงพอ';
      }
    } else {
      recommendation =
          'แนะนำใช้พลังงานแสงอาทิตย์พร้อมแหล่งพลังงานอื่นๆ เพื่อเสริมการผลิตพลังงาน';
      if (roofArea < 10) {
        recommendation += ' และพิจารณาเพิ่มพื้นที่หลังคาสำหรับแผงโซลาร์เซลล์';
      }
    }

    return recommendation;
  }

  // ฟังก์ชันวิเคราะห์และแสดงคำแนะนำพลังงานหมุนเวียนที่เหมาะสม
  Future<Map<String, dynamic>> fetchAndAnalyzeData({
    required double lat,
    required double lon,
    required double averageEnergyUsage,
    required double roofArea,
    required String roofDirection,
  }) async {
    try {
      final weatherData = await fetchWeatherData(lat, lon);
      print('Weather data: ${weatherData.toString()}');

      int sunrise = weatherData['current']['sunrise'];
      int sunset = weatherData['current']['sunset'];
      double sunlightHours = calculateSunlightHours(sunrise, sunset);
      double windSpeed = (weatherData['current']['wind_speed'] ?? 0).toDouble();

      print('Before adjustment - Sunlight Hours: $sunlightHours');
      print('Before adjustment - Wind Speed: $windSpeed');

      sunlightHours = sunlightHours.isFinite ? sunlightHours : 0.0;
      windSpeed = windSpeed.isFinite ? windSpeed : 0.0;

      print('After adjustment - Sunlight Hours: $sunlightHours');
      print('After adjustment - Wind Speed: $windSpeed');

      _sunlightHours = sunlightHours;
      _windSpeed = windSpeed;
      notifyListeners();

      String recommendation = await analyzeAndRecommendEnergy(
        sunlightHours: sunlightHours,
        windSpeed: windSpeed,
        averageEnergyUsage: averageEnergyUsage,
        roofArea: roofArea,
        roofDirection: roofDirection,
      );

      return {
        'recommendation': recommendation,
        'sunlightHours': sunlightHours,
        'windSpeed': windSpeed,
      };
    } catch (e) {
      print('Error fetching or analyzing data: $e');
      return {
        'recommendation': 'เกิดข้อผิดพลาดในการแนะนำพลังงานหมุนเวียน',
        'sunlightHours': 0.0,
        'windSpeed': 0.0,
      };
    }
  }

  // ฟังก์ชันลบข้อมูลพลังงานหมุนเวียน
  void deleteEnergy(int? index) async {
    var db = RenewableEnergyDB(dbName: 'renewable_energy.db');
    await db.deleteDatabase(index);
    this.energies = await db.loadAllData();
    notifyListeners();
  }

  void updateEnergy(RenewableEnergy updatedEnergy) {
  int index = energies.indexWhere((e) => e.keyID == updatedEnergy.keyID);
  if (index != -1) {
    energies[index] = updatedEnergy;
    notifyListeners();
  }
}
}
