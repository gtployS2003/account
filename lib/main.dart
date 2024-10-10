import 'package:account/screens/form_screen.dart';
import 'package:account/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:account/provider/renewable_energy_provider.dart';  // เปลี่ยนจาก TransactionProvider เป็น RenewableEnergyProvider

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

    @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return RenewableEnergyProvider();  // เปลี่ยนเป็น RenewableEnergyProvider
        }),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'Sarabun',  // ใช้ฟอนต์ Sarabun ที่รองรับภาษาไทย
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
        locale: const Locale('th', 'TH'),  // กำหนดค่า locale ให้รองรับภาษาไทย
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('th', 'TH'),
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        home: const MyHomePage(),  // ใช้ MyHomePage เป็นหน้าเริ่มต้น
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<RenewableEnergyProvider>(context, listen: false).initData();
  });
}

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(
          children: [
            HomeScreen(),    // หน้าแสดงรายการพลังงานหมุนเวียน
            FormScreen(),    // หน้าเพิ่มข้อมูลพลังงานหมุนเวียน
          ],
        ),
        bottomNavigationBar: const TabBar(
          tabs: [
            Tab(text: "Energy List", icon: Icon(Icons.list)),  // เปลี่ยนข้อความให้สอดคล้องกับโปรเจ็ค
            Tab(text: "Add Data", icon: Icon(Icons.add)),
          ],
        ),
      ),
    );
  }
}
