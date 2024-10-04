import 'package:account/screens/form_screen.dart';
import 'package:account/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:account/provider/renewable_energy_provider.dart';  // เปลี่ยนจาก TransactionProvider เป็น RenewableEnergyProvider

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return RenewableEnergyProvider();  // เปลี่ยนเป็น RenewableEnergyProvider
        }),
      ],
      child: MaterialApp(
        title: 'แอปพลังงานหมุนเวียน',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(),
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
    // โหลดข้อมูลพลังงานหมุนเวียน
    super.initState();
    Provider.of<RenewableEnergyProvider>(context, listen: false).initData();  // เปลี่ยนเป็น RenewableEnergyProvider
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
              Tab(text: "รายการพลังงาน", icon: Icon(Icons.list)),  // เปลี่ยนข้อความให้สอดคล้องกับโปรเจ็ค
              Tab(text: "เพิ่มข้อมูล", icon: Icon(Icons.add)),
            ],
          ),
        ));
  }
}
