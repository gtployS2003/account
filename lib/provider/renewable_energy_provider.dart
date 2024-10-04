import 'package:account/databases/renewable_energy_db.dart';
import 'package:flutter/foundation.dart';
import 'package:account/models/renewable_energy.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RenewableEnergyProvider with ChangeNotifier {
  List<RenewableEnergy> energies = [];

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
      notifyListeners();
    }
  }

  // ฟังก์ชันสำหรับดึงข้อมูลสภาพอากาศจาก API
  Future<Map<String, dynamic>> fetchWeatherData(double lat, double lon) async {
    final apiKey = 'your_api_key';  // แทนที่ด้วย API Key ของคุณ
    final url = 'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&exclude=minutely,hourly&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // ฟังก์ชันวิเคราะห์ข้อมูลบ้านเพื่อแนะนำพลังงานหมุนเวียนที่เหมาะสม
  Future<String> analyzeAndRecommendEnergy(double sunlightHours, double windSpeed) async {
    String recommendation;

    // วิเคราะห์ข้อมูลสภาพอากาศ
    if (sunlightHours > 5) {
      recommendation = 'แนะนำพลังงานแสงอาทิตย์ (Solar Energy)';
    } else if (windSpeed > 10) {
      recommendation = 'แนะนำพลังงานลม (Wind Energy)';
    } else {
      recommendation = 'แนะนำใช้พลังงานแสงอาทิตย์พร้อมแหล่งพลังงานอื่นๆ';
    }

    return recommendation;
  }

  // ฟังก์ชันวิเคราะห์และแสดงคำแนะนำพลังงานหมุนเวียนที่เหมาะสม
  Future<void> fetchAndAnalyzeData(double lat, double lon) async {
    try {
      final weatherData = await fetchWeatherData(lat, lon);
      double sunlightHours = weatherData['current']['uvi'];  // ใช้ดัชนี UV แทนปริมาณแสงแดด
      double windSpeed = weatherData['current']['wind_speed'];

      String recommendation = await analyzeAndRecommendEnergy(sunlightHours, windSpeed);
      print('คำแนะนำพลังงานหมุนเวียนที่เหมาะสม: $recommendation');
    } catch (e) {
      print('Error fetching or analyzing data: $e');
    }
  }

  // ฟังก์ชันลบข้อมูลพลังงานหมุนเวียน
  void deleteEnergy(int? index) async {
    var db = RenewableEnergyDB(dbName: 'renewable_energy.db');
    await db.deleteDatabase(index);
    this.energies = await db.loadAllData();
    notifyListeners();
  }
}
