import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'addproduct.dart';
import 'showproductgrid.dart';
import 'showproducttype.dart';

// Method หลักที่ Run
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyDj2sJB9VPkHh9WHdBeAWd4Khsj-UhpDCk",
            authDomain: "onlinefirebase-4d9bc.firebaseapp.com",
            databaseURL:
                "https://onlinefirebase-4d9bc-default-rtdb.firebaseio.com",
            projectId: "onlinefirebase-4d9bc",
            storageBucket: "onlinefirebase-4d9bc.firebasestorage.app",
            messagingSenderId: "825738727223",
            appId: "1:825738727223:web:f8e55a17803658e224d4b2",
            measurementId: "G-KHBD6Z609K"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

// Class Stateless สั่งแสดงผลหน้าจอ
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: Main(),
      debugShowCheckedModeBanner: false, // ปิดการแสดง debug banner
    );
  }
}

// Class Stateful เรียกใช้การทำงานแบบโต้ตอบ
class Main extends StatefulWidget {
  @override
  State<Main> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('เมนูหลัก'),
        backgroundColor:
            Colors.yellow, // เปลี่ยนสีพื้นหลังของ AppBar เป็นสีเหลือง
        foregroundColor:
            Colors.black, // เปลี่ยนสีข้อความและไอคอนใน AppBar เป็นสีดำ
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(
                16.0), // เพิ่ม padding รอบๆ ให้กับทั้งหน้าจอ
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.start, // จัดแนวในแนวตั้งให้เริ่มจากด้านบน
              crossAxisAlignment:
                  CrossAxisAlignment.center, // จัดแนวกลางในแนวนอน
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0),
                  child: Image.asset(
                    'assets/logo.jpg',
                    width: 250,
                    height: 250,
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => addproduct(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow, // สีพื้นหลังของปุ่ม
                    foregroundColor: Colors.black, // สีของข้อความ
                    side: BorderSide(
                        color: Colors.black, width: 2), // สีและขนาดของกรอบ
                    fixedSize: Size(200, 50), // ขนาดของปุ่ม
                  ),
                  child: Text(
                    'จัดการข้อมูลสินค้า',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => showproductgrid(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.black, width: 2),
                    fixedSize: Size(200, 50),
                  ),
                  child: Text(
                    'แสดงข้อมูลสินค้า',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => showproducttype(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    side: BorderSide(color: Colors.black, width: 2),
                    fixedSize: Size(200, 50),
                  ),
                  child: Text(
                    'ประเภทสินค้า',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
