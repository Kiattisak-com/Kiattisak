import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:onlineapp_kiattisak/showproduct.dart';

//Method หลักทีRun
void main() {
  runApp(MyApp());
}

//Class stateless สั่งแสดงผลหนาจอ
class MyApp extends StatelessWidget {
  const MyApp({super.key});
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: addproduct(),
      debugShowCheckedModeBanner: false, // ปิดการแสดง debug banner
    );
  }
}

//Class stateful เรียกใช้การทํางานแบบโต้ตอบ
class addproduct extends StatefulWidget {
  @override
  State<addproduct> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<addproduct> {
//ส่วนเขียน Code ภาษา dart เพื่อรับค่าจากหน้าจอมาคํานวณหรือมาทําบางอย่างและส่งค่ากลับไป
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController desController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final categories = ['Electronics', 'Clothing', 'Food', 'Books'];
  String? selectedCategory;

//ประกาศตัวแปรเก็บคาการเลือกวันที่
  DateTime? productionDate;
//สรางฟงกชันใหเลือกวันที่
  Future<void> pickProductionDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: productionDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != productionDate) {
      setState(() {
        productionDate = pickedDate;
        dateController.text =
            "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> saveProductToDatabase() async {
    try {
// สร้าง reference ไปยัง Firebase Realtime Database
      DatabaseReference dbRef = FirebaseDatabase.instance.ref('products');
//ข้อมูลสินค้าที่จะจัดเก็บในรูปแบบ Map
      //ชื่อตัวแปรที่รับค่าที่ผู้ใช้ป้อนจากฟอร์มต้องตรงกับชื่อตัวแปรที่ตั้งตอนสร้างฟอร์มเพื่อรับค่า
      Map<String, dynamic> productData = {
        'name': nameController.text,
        'description': desController.text,
        'category': selectedCategory,
        'productionDate': productionDate?.toIso8601String(),
        'price': double.parse(priceController.text),
        'quantity': int.parse(quantityController.text),
      };
//ใช้คําสั่ง push() เพื่อสร้าง key อัตโนมัติสําหรับสินค้าใหม่
      await dbRef.push().set(productData);
//แจ้งเตือนเมื่อบันทึกสําเร็จ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('บันทึกข้อมูลสําเร็จ')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowProduct(),
        ),
      );
// รีเซ็ตฟอร์ม
      _formKey.currentState?.reset();
      nameController.clear();
      desController.clear();
      priceController.clear();
      quantityController.clear();
      dateController.clear();
      setState(() {
        selectedCategory = null;
        productionDate = null;
      });
    } catch (e) {
//แจ้งเตือนเมื่อเกิดข้อผิดพลาด
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
      );
    }
  }

//ส่วนการออกแบบหน้าจอ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('จัดการข้อมูลสินค้า'),
        backgroundColor:
            Colors.yellow, // เปลี่ยนสีพื้นหลังของ AppBar เป็นสีเหลือง
        foregroundColor:
            Colors.black, // เปลี่ยนสีข้อความและไอคอนใน AppBar เป็นสีดำ
      ),
      body: SingleChildScrollView(
        // เพิ่ม Padding เพื่อเว้นขอบจอ
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch, // ขยายปุ่มให้กว้างเท่ากับจอ
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      labelText: 'ชื่อสินค้า',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกชื่อสินค้า';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: desController,
                  maxLines: 3, // เขียนไม่เกิน 2 บรรทัด
                  decoration: InputDecoration(
                      labelText: 'รายละเอียดสินค้า',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกรายละเอียด';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                      labelText: 'ประเภทสินค้า',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  items: categories
                      .map((category) => DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาเลือกประเภทสินค้า';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                      labelText: 'วันที่ผลิตสินค้า',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => pickProductionDate(context),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาเลือกวันที่ผลิต';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(
                      labelText: 'จำนวนตัวเลข',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกจำนวนสินค้า';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(
                      labelText: 'จำนวนสินค้า',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณากรอกจำนวนตัวเลข';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                // ใช้ Center เพื่อวางปุ่มให้อยู่ตรงกลาง
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // ดำเนินการเมื่อฟอร์มผ่านการตรวจสอบ
                        saveProductToDatabase();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ), // ขนาดของปุ่ม
                      side: BorderSide(
                        // เพิ่มกรอบรอบปุ่ม
                        color: Colors.black, // สีของกรอบเป็นสีดำ
                        width: 2, // ความหนาของกรอบ
                      ),
                      shape: RoundedRectangleBorder(
                        // ทำให้ปุ่มมีมุมมน
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor:
                          Colors.yellow, // สีพื้นหลังของปุ่มเปลี่ยนเป็นสีเหลือง
                    ),
                    child: Text(
                      'บันทึกสินค้า',
                      style: TextStyle(
                        color: Colors.black, // สีข้อความเปลี่ยนเป็นสีดำ
                        fontSize: 18, // เพิ่มขนาดตัวอักษร
                        fontWeight:
                            FontWeight.bold, // ทำให้ข้อความหนาขึ้น (ตัวหนา)
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
